import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';
import 'package:manage_state/data/notifications/models/notification_item_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationItemModel>> getNewNotifications();
  Future<List<NotificationItemModel>> getTodayNotifications();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final ApiClient apiClient;

  NotificationsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<NotificationItemModel>> getNewNotifications() async {
    final response = await apiClient.get(ApiEndpoints.newNotifications);

    if (response is List) {
      return response
          .map((json) =>
              NotificationItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<NotificationItemModel>> getTodayNotifications() async {
    final response = await apiClient.get(ApiEndpoints.todayNotifications);

    if (response is List) {
      return response
          .map((json) =>
              NotificationItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
