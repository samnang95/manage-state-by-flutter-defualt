import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage_state/core/services/native_camera_service.dart';
import 'package:manage_state/core/services/native_file_service.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/presentation/camera/widgets/camera_web_view.dart';

class NativeCameraPage extends StatefulWidget {
  const NativeCameraPage({super.key});

  @override
  State<NativeCameraPage> createState() => _NativeCameraPageState();
}

class _NativeCameraPageState extends State<NativeCameraPage> {
  final NativeCameraService _cameraService = NativeCameraService();
  final NativeFileService _fileService = NativeFileService();
  final GlobalKey _webCameraKey = GlobalKey();

  bool _isMirrored = true;
  bool _isCapturing = false;
  bool _isSaving = false;
  Uint8List? _capturedBytes;
  Future<int?>? _cameraFuture;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _cameraFuture = _cameraService.startCamera();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      stopCurrentWebCamera();
    } else {
      _cameraService.stopCamera();
    }
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      Uint8List? bytes;
      if (kIsWeb) {
        final state = _webCameraKey.currentState;
        if (state is WebCameraController) {
          bytes = await (state as WebCameraController).takePhoto();
        } else {
          debugPrint('Web camera state error: state=$state, key=$_webCameraKey');
        }
      } else {
        bytes = await _cameraService.takePhoto();
      }

      if (bytes != null && mounted) {
        setState(() {
          _capturedBytes = bytes;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture photo frame.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _savePhoto() async {
    if (_capturedBytes == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      if (kIsWeb) {
        downloadWebPhoto(_capturedBytes!, fileName);
        if (mounted) {
          Navigator.pop(context, {
            'path': fileName,
            'bytes': _capturedBytes,
          });
        }
      } else {
        final savedPath = await _fileService.saveImageBytes(_capturedBytes!, fileName);
        if (savedPath != null && mounted) {
          Navigator.pop(context, {
            'path': savedPath,
            'bytes': _capturedBytes,
          });
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image to disk.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          _capturedBytes != null
              ? 'Photo Preview'
              : (kIsWeb ? 'Web Camera' : 'Native Camera'),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_capturedBytes != null) {
              setState(() => _capturedBytes = null);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _capturedBytes != null ? _buildPreviewScreen() : _buildLiveCameraScreen(),
    );
  }

  Widget _buildPreviewScreen() {
    return Stack(
      children: [
        Center(
          child: Image.memory(
            _capturedBytes!,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _isSaving
                    ? null
                    : () {
                        setState(() => _capturedBytes = null);
                        if (!kIsWeb) {
                          _cameraService.resumeCamera();
                        }
                      },
                icon: const Icon(Icons.refresh),
                label: const Text('Retake', style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _isSaving ? null : _savePhoto,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  _isSaving ? 'Saving...' : 'Save & Use',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveCameraScreen() {
    return Stack(
      children: [
        if (kIsWeb)
          buildWebCameraView(controllerKey: _webCameraKey)
        else
          FutureBuilder<int?>(
            future: _cameraFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.videocam_off, color: Colors.white54, size: 48),
                      const SizedBox(height: 12),
                      const Text(
                        'Failed to initialize camera or permission denied.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _cameraFuture = _cameraService.startCamera();
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              Widget preview = Texture(textureId: snapshot.data!);
              if (defaultTargetPlatform == TargetPlatform.android && _isMirrored) {
                preview = Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: preview,
                );
              }

              if (defaultTargetPlatform == TargetPlatform.macOS) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: preview,
                  ),
                );
              }

              if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: preview,
                  ),
                );
              }

              return Center(child: preview);
            },
          ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Mirror Toggle Button
              FloatingActionButton.small(
                heroTag: 'mirror_btn',
                tooltip: _isMirrored ? 'Mirror: On' : 'Mirror: Off',
                backgroundColor: _isMirrored ? AppColors.primary : Colors.white24,
                elevation: 0,
                onPressed: () async {
                  if (kIsWeb) {
                    final state = _webCameraKey.currentState;
                    if (state is WebCameraController) {
                      final newMirrored = (state as WebCameraController).toggleMirror();
                      setState(() {
                        _isMirrored = newMirrored;
                      });
                    }
                  } else {
                    final newMirrored = await _cameraService.toggleMirror();
                    if (newMirrored != null && mounted) {
                      setState(() {
                        _isMirrored = newMirrored;
                      });
                    }
                  }
                },
                child: const Icon(Icons.flip, color: Colors.white),
              ),

              // Shutter Button
              GestureDetector(
                onTap: _isCapturing ? null : _capturePhoto,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Center(
                    child: _isCapturing
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              // Switch Camera Button
              FloatingActionButton(
                heroTag: 'switch_btn',
                tooltip: 'Switch Camera',
                backgroundColor: Colors.white24,
                elevation: 0,
                onPressed: () async {
                  if (kIsWeb) {
                    final state = _webCameraKey.currentState;
                    if (state is WebCameraController) {
                      (state as WebCameraController).switchCamera();
                    }
                  } else {
                    final newMirrored = await _cameraService.switchCamera();
                    if (newMirrored != null && mounted) {
                      setState(() {
                        _isMirrored = newMirrored;
                      });
                    }
                  }
                },
                child: const Icon(Icons.flip_camera_android, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
