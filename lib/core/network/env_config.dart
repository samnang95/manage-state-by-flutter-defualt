class EnvConfig {
  // Read from environment variable using:
  // flutter run --dart-define=BASE_URL=https://api.example.com
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );
}
