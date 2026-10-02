class ApiEndpoints {
  ApiEndpoints._();

  // --- Auth ---
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';

  // --- Profile ---
  static const String profile = '/users/me/profile';
  static const String updateProfile = '/users/me/update';
  static const String me = '/users/me';

  // --- Home ---
  static const String homeFeed = '/home/feed';
  static const String stories = '/home/stories';
  static const String createPost = '/home/posts';

  // --- Comments ---
  static const String comments = '/comments';

  // --- Reels ---
  static const String reels = '/reels';

  // --- Friends ---
  static const String friendRequests = '/friends/requests';

  // --- Marketplace ---
  static const String marketplaceItems = '/marketplace/items';

  // --- Notifications ---
  static const String notifications = '/notifications';
  static const String newNotifications = '/notifications/new';
  static const String todayNotifications = '/notifications/today';

  // --- Upload ---
  static const String upload = '/upload';
}
