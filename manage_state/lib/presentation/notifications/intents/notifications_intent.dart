sealed class NotificationsIntent {
  const NotificationsIntent();
}

class LoadNotificationsIntent extends NotificationsIntent {
  const LoadNotificationsIntent();
}

class RefreshNotificationsIntent extends NotificationsIntent {
  const RefreshNotificationsIntent();
}

class MarkNotificationAsReadIntent extends NotificationsIntent {
  final String id;
  const MarkNotificationAsReadIntent(this.id);
}

class ToggleNotificationReadIntent extends NotificationsIntent {
  final String id;
  const ToggleNotificationReadIntent(this.id);
}

class MarkAllNotificationsAsReadIntent extends NotificationsIntent {
  const MarkAllNotificationsAsReadIntent();
}
