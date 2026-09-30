import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeCameraService {
  static const MethodChannel _channel = MethodChannel('com.example.manage_state/camera');

  Future<int?> startCamera() async {
    if (kIsWeb) return null;
    try {
      final int? textureId = await _channel.invokeMethod<int>('startCamera');
      return textureId;
    } catch (e) {
      debugPrint("Failed to start camera: '$e'.");
      return null;
    }
  }

  Future<bool?> switchCamera() async {
    if (kIsWeb) return null;
    try {
      final bool? isMirrored = await _channel.invokeMethod<bool>('switchCamera');
      return isMirrored;
    } catch (e) {
      debugPrint("Failed to switch camera: '$e'.");
      return null;
    }
  }

  Future<bool?> toggleMirror() async {
    if (kIsWeb) return null;
    try {
      final bool? isMirrored = await _channel.invokeMethod<bool>('toggleMirror');
      return isMirrored;
    } catch (e) {
      debugPrint("Failed to toggle mirror: '$e'.");
      return null;
    }
  }

  Future<Uint8List?> takePhoto() async {
    if (kIsWeb) return null;
    try {
      final Uint8List? bytes = await _channel.invokeMethod<Uint8List>('takePhoto');
      return bytes;
    } catch (e) {
      debugPrint("Failed to take photo: '$e'.");
      return null;
    }
  }

  Future<void> resumeCamera() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('resumeCamera');
    } catch (e) {
      debugPrint("Failed to resume camera: '$e'.");
    }
  }

  Future<void> stopCamera() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('stopCamera');
    } catch (e) {
      debugPrint("Failed to stop camera: '$e'.");
    }
  }
}
