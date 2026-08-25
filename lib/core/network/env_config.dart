class EnvConfig {
  // Read from environment variable using:
  // flutter run --dart-define=BASE_URL=https://dummyjson.com
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );
}
