import 'package:flutter/material.dart';
import 'package:manage_state/core/services/native_camera_service.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class NativeCameraPage extends StatelessWidget {
  NativeCameraPage({super.key});

  final NativeCameraService _cameraService = NativeCameraService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Native Camera'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
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

              return Center(
                child: Texture(textureId: snapshot.data!),
              );
            },
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Colors.white24,
              elevation: 0,
              onPressed: () => _cameraService.switchCamera(),
              child: const Icon(Icons.flip_camera_android, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
