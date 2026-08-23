import 'package:manage_state/data/friends/models/friend_request_model.dart';

abstract class FriendsRemoteDataSource {
  Future<List<FriendRequestModel>> getFriendRequests();
}

class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  @override
  Future<List<FriendRequestModel>> getFriendRequests() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final data = [
      {
        'name': 'Key Som',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'mutualFriends': 22,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=10',
          'https://i.pravatar.cc/50?img=11',
        ],
        'timeAgo': '2d',
        'isOnline': false,
      },
      {
        'name': 'Vy Vy',
        'avatar': 'https://i.pravatar.cc/150?img=16',
        'mutualFriends': 29,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=12',
          'https://i.pravatar.cc/50?img=13',
        ],
        'timeAgo': '2w',
        'isOnline': true,
      },
      {
        'name': 'Rith Ravid',
        'avatar': 'https://i.pravatar.cc/150?img=26',
        'mutualFriends': 34,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=14',
          'https://i.pravatar.cc/50?img=15',
        ],
        'timeAgo': '2w',
        'isOnline': true,
      },
      {
        'name': 'Ava Luna',
        'avatar': 'https://i.pravatar.cc/150?img=9',
        'mutualFriends': 1,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=18',
        ],
        'timeAgo': '3w',
        'isOnline': false,
      },
      {
        'name': 'Vi Saufong',
        'avatar': 'https://i.pravatar.cc/150?img=57',
        'mutualFriends': 5,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=20',
          'https://i.pravatar.cc/50?img=21',
        ],
        'timeAgo': '2w',
        'isOnline': false,
      },
      {
        'name': 'David Chen',
        'avatar': 'https://i.pravatar.cc/150?img=33',
        'mutualFriends': 12,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=22',
          'https://i.pravatar.cc/50?img=23',
        ],
        'timeAgo': '1w',
        'isOnline': false,
      },
      {
        'name': 'Sophia Park',
        'avatar': 'https://i.pravatar.cc/150?img=45',
        'mutualFriends': 8,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=24',
          'https://i.pravatar.cc/50?img=25',
        ],
        'timeAgo': '4d',
        'isOnline': true,
      },
      {
        'name': 'Mia Thompson',
        'avatar': 'https://i.pravatar.cc/150?img=27',
        'mutualFriends': 15,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=30',
          'https://i.pravatar.cc/50?img=31',
        ],
        'timeAgo': '1d',
        'isOnline': true,
      },
      {
        'name': 'Ethan Brown',
        'avatar': 'https://i.pravatar.cc/150?img=52',
        'mutualFriends': 41,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=32',
          'https://i.pravatar.cc/50?img=33',
        ],
        'timeAgo': '3d',
        'isOnline': false,
      },
      {
        'name': 'Luna Garcia',
        'avatar': 'https://i.pravatar.cc/150?img=28',
        'mutualFriends': 7,
        'mutualAvatars': [
          'https://i.pravatar.cc/50?img=34',
        ],
        'timeAgo': '1w',
        'isOnline': false,
      },
    ];

    return data.map((json) => FriendRequestModel.fromJson(json)).toList();
  }
}
