abstract class TokenManager {
  String? get accessToken;
  String? get refreshToken;

  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<void> clearTokens();
  bool get hasToken;
}

class InMemoryTokenManager implements TokenManager {
  String? _accessToken;
  String? _refreshToken;

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  bool get hasToken => _accessToken != null && _accessToken!.isNotEmpty;

  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
  }
}
