import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/notifications/usecases/get_notifications_usecase.dart';
import 'package:manage_state/presentation/notifications/intents/notifications_intent.dart';
import 'package:manage_state/presentation/notifications/states/notifications_state.dart';

class NotificationsController
    extends MviController<NotificationsIntent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationsController({required this.getNotificationsUseCase})
      : super(const NotificationsState()) {
    onIntent(const LoadNotificationsIntent());
  }

  @override
  void onIntent(NotificationsIntent intent) {
    switch (intent) {
      case LoadNotificationsIntent():
        _handleLoadData();
      case RefreshNotificationsIntent():
        _handleRefreshData();
      case MarkNotificationAsReadIntent(:final id):
        _handleMarkAsRead(id);
      case ToggleNotificationReadIntent(:final id):
        _handleToggleRead(id);
      case MarkAllNotificationsAsReadIntent():
        _handleMarkAllAsRead();
    }
  }

  Future<void> _handleLoadData() async {
    emit(value.copyWith(isLoading: true, errorMessage: null));

    try {
      final notifs = await getNotificationsUseCase();
      emit(value.copyWith(
        isLoading: false,
        newNotifications: notifs['new'] ?? [],
        todayNotifications: notifs['today'] ?? [],
      ));
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      emit(value.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _handleRefreshData() async {
    try {
      final notifs = await getNotificationsUseCase();
      emit(value.copyWith(
        newNotifications: notifs['new'] ?? [],
        todayNotifications: notifs['today'] ?? [],
      ));
    } catch (e) {
      debugPrint('Error refreshing notifications: $e');
    }
  }

  void _handleMarkAsRead(String id) {
    bool updated = false;

    for (final n in value.newNotifications) {
      if (n.id == id && !n.isRead) {
        n.isRead = true;
        updated = true;
        break;
      }
    }

    if (!updated) {
      for (final n in value.todayNotifications) {
        if (n.id == id && !n.isRead) {
          n.isRead = true;
          updated = true;
          break;
        }
      }
    }

    if (updated) {
      emit(value.copyWith(
        newNotifications: List.of(value.newNotifications),
        todayNotifications: List.of(value.todayNotifications),
      ));
    }
  }

  void _handleToggleRead(String id) {
    bool updated = false;

    for (final n in [...value.newNotifications, ...value.todayNotifications]) {
      if (n.id == id) {
        n.isRead = !n.isRead;
        updated = true;
        break;
      }
    }

    if (updated) {
      emit(value.copyWith(
        newNotifications: List.of(value.newNotifications),
        todayNotifications: List.of(value.todayNotifications),
      ));
    }
  }

  void _handleMarkAllAsRead() {
    for (final n in value.newNotifications) {
      n.isRead = true;
    }
    for (final n in value.todayNotifications) {
      n.isRead = true;
    }

    emit(value.copyWith(
      newNotifications: List.of(value.newNotifications),
      todayNotifications: List.of(value.todayNotifications),
    ));
  }
}
