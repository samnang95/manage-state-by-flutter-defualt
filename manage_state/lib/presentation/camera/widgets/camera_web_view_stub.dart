import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget createWebCameraView({Key? key, dynamic controllerKey}) {
  return const SizedBox.shrink();
}

abstract class WebCameraController {
  void switchCamera();
  bool toggleMirror();
  Future<Uint8List?> takePhoto();
  void savePhotoLocally(Uint8List bytes, String filename);
}

void saveWebPhotoLocally(Uint8List bytes, String filename) {}

void stopWebCamera() {}
