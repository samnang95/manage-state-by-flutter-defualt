import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/domain/notifications/entities/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;
  final VoidCallback? onToggleRead;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onToggleRead,
  });

  Color _getBadgeColor(NotificationBadgeType type) {
    switch (type) {
      case NotificationBadgeType.live:
        return Colors.red;
      case NotificationBadgeType.video:
        return Colors.purple;
      case NotificationBadgeType.comment:
      case NotificationBadgeType.mention:
        return Colors.green;
      case NotificationBadgeType.post:
      case NotificationBadgeType.group:
        return const Color(0xFF1877F2);
    }
  }

  IconData _getBadgeIcon(NotificationBadgeType type) {
    switch (type) {
      case NotificationBadgeType.live:
        return Icons.play_circle_filled;
      case NotificationBadgeType.video:
        return Icons.ondemand_video;
      case NotificationBadgeType.comment:
      case NotificationBadgeType.mention:
        return Icons.chat_bubble;
      case NotificationBadgeType.post:
        return Icons.article;
      case NotificationBadgeType.group:
        return Icons.group;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead ? AppColors.white : AppColors.tertiary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(notification.avatarUrl),
                ),
                Positioned(
                  bottom: -2,
                  left: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _getBadgeColor(notification.badgeType),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(
                      _getBadgeIcon(notification.badgeType),
                      size: 12,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text.rich(
                    _buildMessage(notification.message),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Time
                  Text(
                    notification.timeAgo,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.black.withValues(alpha: 0.5),
                    ),
                  ),
                  // Action label
                  if (notification.actionLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      notification.actionLabel!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // More button with popup menu
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'toggle_read') {
                  onToggleRead?.call();
                }
              },
              icon: Icon(
                Icons.more_horiz,
                size: 20,
                color: AppColors.black.withValues(alpha: 0.5),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle_read',
                  child: Row(
                    children: [
                      Icon(
                        notification.isRead
                            ? Icons.mark_email_unread_outlined
                            : Icons.mark_email_read_outlined,
                        size: 20,
                        color: AppColors.black,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        notification.isRead
                            ? 'Mark as unread'
                            : 'Mark as read',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Unread indicator dot
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildMessage(String message) {
    // Bold the first name/entity in the message
    final colonIndex = message.indexOf(' ');
    final secondSpace = message.indexOf(' ', colonIndex + 1);
    if (secondSpace > 0) {
      final boldPart = message.substring(0, secondSpace);
      final rest = message.substring(secondSpace);
      return TextSpan(
        children: [
          TextSpan(
            text: boldPart,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: rest),
        ],
      );
    }
    return TextSpan(text: message);
  }
}
