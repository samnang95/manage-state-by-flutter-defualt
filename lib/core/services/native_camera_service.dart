import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeCameraService {
  static const MethodChannel _channel = MethodChannel('com.example.manage_state/camera');

  Future<int?> startCamera() async {
    try {
      final int textureId = await _channel.invokeMethod('startCamera');
      return textureId;
    } on PlatformException catch (e) {
      debugPrint("Failed to start camera: '${e.message}'.");
      return null;
    }
  }

  Future<void> switchCamera() async {
    try {
      await _channel.invokeMethod('switchCamera');
    } on PlatformException catch (e) {
      debugPrint("Failed to switch camera: '${e.message}'.");
    }
  }
}
