import 'package:manage_state/domain/notifications/entities/notification_item.dart';

class NotificationItemModel extends NotificationItem {
  NotificationItemModel({
    required super.id,
    required super.avatarUrl,
    required super.message,
    required super.timeAgo,
    super.actionLabel,
    required super.badgeType,
    super.isRead = false,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'],
      avatarUrl: json['avatarUrl'],
      message: json['message'],
      timeAgo: json['timeAgo'],
      actionLabel: json['actionLabel'],
      badgeType: NotificationBadgeType.values.firstWhere(
        (e) => e.toString() == 'NotificationBadgeType.${json['badgeType']}',
      ),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatarUrl': avatarUrl,
      'message': message,
      'timeAgo': timeAgo,
      'actionLabel': actionLabel,
      'badgeType': badgeType.toString().split('.').last,
      'isRead': isRead,
    };
  }
}
