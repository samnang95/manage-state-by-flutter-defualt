import 'package:flutter/material.dart';

Widget createWebCameraView({Key? key, dynamic controllerKey}) {
  return const SizedBox.shrink();
}

abstract class WebCameraController {
  void switchCamera();
  bool toggleMirror();
}
