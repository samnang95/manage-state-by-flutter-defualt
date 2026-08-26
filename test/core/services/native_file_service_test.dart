import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manage_state/core/services/native_file_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NativeFileService', () {
    late NativeFileService service;
    const MethodChannel channel = MethodChannel('com.example.manage_state/file');

    setUp(() {
      service = NativeFileService();
    });

    test('pickFile returns path on success', () async {
      // 1. Arrange: Mock the native method channel response so we don't need any external packages
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'pickFile') {
          return '/path/to/mock/file.txt';
        }
        return null;
      });

      // 2. Act
      final result = await service.pickFile();
      
      // 3. Assert
      expect(result, '/path/to/mock/file.txt');
    });
    
    test('pickFile returns null on PlatformException', () async {
      // 1. Arrange: Mock an error from the native side
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'pickFile') {
          throw PlatformException(code: 'ERROR', message: 'Failed to pick');
        }
        return null;
      });

      // 2. Act
      final result = await service.pickFile();
      
      // 3. Assert
      expect(result, isNull);
    });

    tearDown(() {
      // Clear the mock handler after tests
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });
}
