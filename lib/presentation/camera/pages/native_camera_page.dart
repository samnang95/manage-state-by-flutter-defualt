import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage_state/core/services/native_camera_service.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/presentation/camera/widgets/camera_web_view.dart';
import 'package:manage_state/presentation/camera/widgets/camera_web_view_stub.dart';

class NativeCameraPage extends StatefulWidget {
  const NativeCameraPage({super.key});

  @override
  State<NativeCameraPage> createState() => _NativeCameraPageState();
}

class _NativeCameraPageState extends State<NativeCameraPage> {
  final NativeCameraService _cameraService = NativeCameraService();
  final GlobalKey _webCameraKey = GlobalKey();
  bool _isMirrored = true;

  @override
  void dispose() {
    if (!kIsWeb) {
      _cameraService.stopCamera();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(kIsWeb ? 'Web Camera' : 'Native Camera'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          if (kIsWeb)
            buildWebCameraView(controllerKey: _webCameraKey)
          else
            FutureBuilder<int?>(
              future: _cameraService.startCamera(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'Failed to initialize camera or permission denied.',
                      style: TextStyle(color: Colors.white),
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

                return Center(child: preview);
              },
            ),
          Positioned(
            bottom: 30,
            right: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(width: 16),
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
      ),
    );
  }
}
