class EnvConfig {
  static const String _envBaseUrl = String.fromEnvironment('BASE_URL');

  /// Local network Wi-Fi/LAN IP of the host machine running the API server.
  static const String hostIp = '192.168.9.242';
  static const String port = '3001';

  /// Pre-configured base URLs
  static String get networkUrl => 'http://$hostIp:$port';
  static String get localhostUrl => 'http://localhost:$port';
  static String get androidEmulatorUrl => 'http://10.0.2.2:$port';

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }
    return networkUrl;
  }
}
