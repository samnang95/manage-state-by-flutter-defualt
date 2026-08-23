import 'package:manage_state/data/notifications/models/notification_item_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationItemModel>> getNewNotifications();
  Future<List<NotificationItemModel>> getTodayNotifications();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  @override
  Future<List<NotificationItemModel>> getNewNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = [
      {
        'id': '1',
        'avatarUrl': 'https://i.pravatar.cc/150?img=30',
        'message': 'MLBB Video was live: "Live from App Support"',
        'timeAgo': '1h',
        'badgeType': 'live',
        'isRead': false,
      },
    ];
    return data.map((json) => NotificationItemModel.fromJson(json)).toList();
  }

  @override
  Future<List<NotificationItemModel>> getTodayNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = [
      {
        'id': '2',
        'avatarUrl': 'https://i.pravatar.cc/150?img=31',
        'message': 'MLBB Video has 12 new views.',
        'timeAgo': '20h',
        'actionLabel': 'MLBB Video',
        'badgeType': 'video',
        'isRead': true,
      },
      {
        'id': '3',
        'avatarUrl': 'https://i.pravatar.cc/150?img=32',
        'message': 'Sakathat Keang mentioned you in a comment: "វិន សំណាង លេងអត់ Smooth ទេ!"',
        'timeAgo': '18h',
        'actionLabel': 'Like',
        'badgeType': 'comment',
        'isRead': true,
      },
      {
        'id': '4',
        'avatarUrl': 'https://i.pravatar.cc/150?img=33',
        'message': 'Chihay Chhuen mentioned you in his comments.',
        'timeAgo': '15h',
        'badgeType': 'mention',
        'isRead': true,
      },
      {
        'id': '5',
        'avatarUrl': 'https://i.pravatar.cc/150?img=34',
        'message': 'MLBB Video: "Live from App Support"',
        'timeAgo': '18h',
        'badgeType': 'video',
        'isRead': true,
      },
      {
        'id': '6',
        'avatarUrl': 'https://i.pravatar.cc/150?img=35',
        'message': 'ក្រុមនិស្សិត - ITE has a new post.',
        'timeAgo': '18h',
        'badgeType': 'group',
        'isRead': true,
      },
      {
        'id': '7',
        'avatarUrl': 'https://i.pravatar.cc/150?img=36',
        'message': 'ចំណោះដឹងអាយធី IT: "🤖 Manus AI — ទទួលបាន Free Credits! 🎁 ថ្ង..."',
        'timeAgo': '20h',
        'badgeType': 'post',
        'isRead': true,
      },
    ];
    return data.map((json) => NotificationItemModel.fromJson(json)).toList();
  }
}
