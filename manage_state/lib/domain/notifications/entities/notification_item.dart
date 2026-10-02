enum NotificationBadgeType {
  live,
  video,
  comment,
  mention,
  post,
  group,
}

class NotificationItem {
  final String id;
  final String avatarUrl;
  final String message;
  final String timeAgo;
  final String? actionLabel;
  final NotificationBadgeType badgeType;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.avatarUrl,
    required this.message,
    required this.timeAgo,
    this.actionLabel,
    required this.badgeType,
    this.isRead = false,
  });
}
