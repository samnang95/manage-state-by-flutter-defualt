// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'camera_web_view_stub.dart';

Widget createWebCameraView({Key? key, dynamic controllerKey}) {
  return WebCameraPreview(
    key: controllerKey is GlobalKey<WebCameraPreviewState> ? controllerKey : null,
  );
}

class WebCameraPreview extends StatefulWidget {
  const WebCameraPreview({super.key});

  @override
  State<WebCameraPreview> createState() => WebCameraPreviewState();
}

class WebCameraPreviewState extends State<WebCameraPreview> implements WebCameraController {
  html.VideoElement? _videoElement;
  html.MediaStream? _stream;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isFrontCamera = true;
  bool _isMirrored = true;
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'web-camera-view-${DateTime.now().millisecondsSinceEpoch}';
    final video = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.transform = 'scaleX(-1)';
    _videoElement = video;

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _videoElement!,
    );

    _initCamera();
  }

  Future<void> _initCamera() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _stopStream();

    try {
      final constraints = {
        'video': {
          'facingMode': _isFrontCamera ? 'user' : 'environment',
        },
        'audio': false,
      };

      final stream = await html.window.navigator.mediaDevices?.getUserMedia(constraints);
      if (stream != null) {
        _stream = stream;
        _videoElement?.srcObject = stream;
        _applyMirror();

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No camera device found.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Camera access error: $e\nPlease grant camera permissions in your browser.';
        });
      }
    }
  }

  void _applyMirror() {
    _videoElement?.style.transform = _isMirrored ? 'scaleX(-1)' : 'none';
  }

  @override
  bool toggleMirror() {
    _isMirrored = !_isMirrored;
    _applyMirror();
    return _isMirrored;
  }

  @override
  void switchCamera() {
    _isFrontCamera = !_isFrontCamera;
    _isMirrored = _isFrontCamera;
    _applyMirror();
    _initCamera();
  }

  void _stopStream() {
    if (_stream != null) {
      for (final track in _stream!.getTracks()) {
        track.stop();
      }
      _stream = null;
    }
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off, color: Colors.white54, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initCamera,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return HtmlElementView(viewType: _viewType);
  }
}
