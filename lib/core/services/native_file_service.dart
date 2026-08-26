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
}
