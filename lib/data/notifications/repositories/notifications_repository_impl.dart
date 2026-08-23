import 'package:manage_state/data/notifications/datasources/notifications_remote_datasource.dart';
import 'package:manage_state/domain/notifications/entities/notification_item.dart';
import 'package:manage_state/domain/notifications/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationItem>> getNewNotifications() async {
    try {
      return await remoteDataSource.getNewNotifications();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<NotificationItem>> getTodayNotifications() async {
    try {
      return await remoteDataSource.getTodayNotifications();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
