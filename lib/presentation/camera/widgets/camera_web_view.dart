import 'dart:typed_data';
import 'package:flutter/widgets.dart';

import 'camera_web_view_stub.dart'
    if (dart.library.html) 'camera_web_view_web.dart';

export 'camera_web_view_stub.dart' show WebCameraController;
export 'camera_web_view_stub.dart'
    if (dart.library.html) 'camera_web_view_web.dart';

Widget buildWebCameraView({Key? key, dynamic controllerKey}) {
  return createWebCameraView(key: key, controllerKey: controllerKey);
}

void downloadWebPhoto(Uint8List bytes, String filename) {
  saveWebPhotoLocally(bytes, filename);
}

void stopCurrentWebCamera() {
  stopWebCamera();
}
