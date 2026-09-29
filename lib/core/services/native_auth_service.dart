import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class NativeAuthService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.manage_state/auth',
  );

  // TikTok API Constants
  static const String _tiktokClientKey = 'awhvjn926hasa3pg';
  static const String _tiktokClientSecret = 'CcwKDBnHT5bSd0erX1Kr6eRDLym5IwDI';
  static const String _tiktokRedirectUri = 'tiktokauth://callback';

  Future<String?> loginWithFacebook({
    List<String> permissions = const ['public_profile'],
  }) async {
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

  Future<String?> loginWithTikTok() async {
    try {
      // 1. Generate PKCE code verifier and challenge
      final random = Random.secure();
      final verifierBytes = List<int>.generate(32, (_) => random.nextInt(256));
      final codeVerifier = base64UrlEncode(verifierBytes).replaceAll('=', '');

      final challengeBytes = sha256.convert(ascii.encode(codeVerifier)).bytes;
      final codeChallenge = base64UrlEncode(challengeBytes).replaceAll('=', '');

      // Generate a random state string to prevent CSRF
      final stateBytes = List<int>.generate(16, (_) => random.nextInt(256));
      final state = base64UrlEncode(stateBytes).replaceAll('=', '');

      // 2. Construct the authorization URL
      final authUrl = Uri.https('www.tiktok.com', '/v2/auth/authorize/', {
        'client_key': _tiktokClientKey,
        'response_type': 'code',
        'scope': 'user.info.basic',
        'redirect_uri': _tiktokRedirectUri,
        'state': state,
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
      });

      // 3. Open the web browser to authenticate
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'tiktokauth',
      );

      // 4. Extract the code from the callback URL
      final resultUri = Uri.parse(result);
      final returnedState = resultUri.queryParameters['state'];

      if (returnedState != state) {
        throw Exception('Invalid state returned from TikTok auth');
      }

      final code = resultUri.queryParameters['code'];
      if (code == null) {
        final error =
            resultUri.queryParameters['error_description'] ?? 'Unknown error';
        throw Exception('TikTok auth failed: $error');
      }

      // 5. Exchange the authorization code for an access token
      final tokenResponse = await http.post(
        Uri.parse('https://open.tiktokapis.com/v2/oauth/token/'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_key': _tiktokClientKey,
          'client_secret': _tiktokClientSecret,
          'code': code,
          'grant_type': 'authorization_code',
          'redirect_uri': _tiktokRedirectUri,
          'code_verifier': codeVerifier,
        },
      );

      if (tokenResponse.statusCode == 200) {
        final data = jsonDecode(tokenResponse.body);
        return data['access_token'];
      } else {
        throw Exception('Failed to exchange token: ${tokenResponse.body}');
      }
    } catch (e) {
      throw Exception('TikTok login error: $e');
    }
  }
}
