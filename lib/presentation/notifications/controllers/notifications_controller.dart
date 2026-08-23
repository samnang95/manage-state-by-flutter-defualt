import 'package:flutter/material.dart';
import 'package:manage_state/domain/notifications/entities/notification_item.dart';
import 'package:manage_state/domain/notifications/usecases/get_notifications_usecase.dart';

class NotificationsController extends ChangeNotifier {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationsController({required this.getNotificationsUseCase}) {
    _loadData();
  }

  List<NotificationItem> newNotifications = [];
  List<NotificationItem> todayNotifications = [];
  bool isLoading = true;

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final notifs = await getNotificationsUseCase();
      newNotifications = notifs['new'] ?? [];
      todayNotifications = notifs['today'] ?? [];
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  int get unreadCount {
    return newNotifications.where((n) => !n.isRead).length +
        todayNotifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String id) {
    for (final n in newNotifications) {
      if (n.id == id) {
        n.isRead = true;
        notifyListeners();
        return;
      }
    }
    for (final n in todayNotifications) {
      if (n.id == id) {
        n.isRead = true;
        notifyListeners();
        return;
      }
    }
  }

  void toggleRead(String id) {
    for (final n in [...newNotifications, ...todayNotifications]) {
      if (n.id == id) {
        n.isRead = !n.isRead;
        notifyListeners();
        return;
      }
    }
  }

  void markAllAsRead() {
    for (final n in newNotifications) {
      n.isRead = true;
    }
    for (final n in todayNotifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  Future<void> refreshData() async {
    try {
      final notifs = await getNotificationsUseCase();
      newNotifications = notifs['new'] ?? [];
      todayNotifications = notifs['today'] ?? [];
    } catch (e) {
      debugPrint('Error refreshing notifications: $e');
    }
    notifyListeners();
  }
}
