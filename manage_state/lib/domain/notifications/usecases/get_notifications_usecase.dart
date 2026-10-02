import 'package:manage_state/domain/notifications/entities/notification_item.dart';
import 'package:manage_state/domain/notifications/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Map<String, List<NotificationItem>>> call() async {
    final newNotifs = await repository.getNewNotifications();
    final todayNotifs = await repository.getTodayNotifications();
    return {
      'new': newNotifs,
      'today': todayNotifs,
    };
  }
}
