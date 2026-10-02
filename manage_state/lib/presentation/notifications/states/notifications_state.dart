import 'package:manage_state/domain/notifications/entities/notification_item.dart';

class NotificationsState {
  final bool isLoading;
  final List<NotificationItem> newNotifications;
  final List<NotificationItem> todayNotifications;
  final String? errorMessage;

  const NotificationsState({
    this.isLoading = true,
    this.newNotifications = const [],
    this.todayNotifications = const [],
    this.errorMessage,
  });

  int get unreadCount {
    return newNotifications.where((n) => !n.isRead).length +
        todayNotifications.where((n) => !n.isRead).length;
  }

  NotificationsState copyWith({
    bool? isLoading,
    List<NotificationItem>? newNotifications,
    List<NotificationItem>? todayNotifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      newNotifications: newNotifications ?? this.newNotifications,
      todayNotifications: todayNotifications ?? this.todayNotifications,
      errorMessage: errorMessage,
    );
  }
}
