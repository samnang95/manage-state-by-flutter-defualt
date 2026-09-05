import 'package:flutter/services.dart';

class NativeAuthService {
  static const MethodChannel _channel = MethodChannel('com.example.manage_state/auth');

  Future<String?> loginWithFacebook({List<String> permissions = const ['public_profile']}) async {
    try {
      final String? token = await _channel.invokeMethod('loginWithFacebook', {
        'permissions': permissions,
      });
      return token;
    } on PlatformException catch (e) {
      throw Exception(e.message ?? 'Unknown error during Facebook login');
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      final String? token = await _channel.invokeMethod('loginWithGoogle');
      return token;
    } on PlatformException catch (e) {
      throw Exception(e.message ?? 'Unknown error during Google login');
    }
  }
}
