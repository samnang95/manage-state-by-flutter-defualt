import 'package:manage_state/domain/notifications/entities/notification_item.dart';

abstract class NotificationsRepository {
  Future<List<NotificationItem>> getNewNotifications();
  Future<List<NotificationItem>> getTodayNotifications();
}
