import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeFileService {
  static const MethodChannel _channel = MethodChannel('com.example.manage_state/file');

  Future<String?> pickFile() async {
    try {
      final String? filePath = await _channel.invokeMethod('pickFile');
      return filePath;
    } on PlatformException catch (e) {
      debugPrint("Failed to pick file: '${e.message}'.");
      return null;
    }
  }

  Future<String?> saveFileToDocuments(String tempPath, String fileName) async {
    try {
      final String? permanentPath = await _channel.invokeMethod('saveFile', {
        'tempPath': tempPath,
        'fileName': fileName,
      });
      return permanentPath;
    } on PlatformException catch (e) {
      debugPrint("Failed to save file: '${e.message}'.");
      return null;
    }
  }

  Future<String?> saveImageBytes(Uint8List bytes, String fileName) async {
    try {
      final String? permanentPath = await _channel.invokeMethod('saveImageBytes', {
        'bytes': bytes,
        'fileName': fileName,
      });
      return permanentPath;
    } on PlatformException catch (e) {
      debugPrint("Failed to save image bytes: '${e.message}'.");
      return null;
    }
  }

  Future<bool> revealInFinder(String filePath) async {
    if (kIsWeb) return false;
    try {
      final bool? success = await _channel.invokeMethod<bool>('revealInFinder', {
        'path': filePath,
      });
      return success ?? false;
    } on PlatformException catch (e) {
      debugPrint("Failed to reveal file: '${e.message}'.");
      return false;
    }
  }
}
