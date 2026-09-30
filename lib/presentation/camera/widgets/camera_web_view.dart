import 'package:flutter/widgets.dart';

import 'camera_web_view_stub.dart'
    if (dart.library.html) 'camera_web_view_web.dart';

Widget buildWebCameraView({Key? key, dynamic controllerKey}) {
  return createWebCameraView(key: key, controllerKey: controllerKey);
}
