import 'package:manage_state/domain/friends/entities/friend_request.dart';

class FriendRequestModel extends FriendRequest {
  FriendRequestModel({
    required super.name,
    required super.avatar,
    required super.mutualFriends,
    required super.mutualAvatars,
    required super.timeAgo,
    required super.isOnline,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      name: json['name'],
      avatar: json['avatar'],
      mutualFriends: json['mutualFriends'],
      mutualAvatars: List<String>.from(json['mutualAvatars']),
      timeAgo: json['timeAgo'],
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'mutualFriends': mutualFriends,
      'mutualAvatars': mutualAvatars,
      'timeAgo': timeAgo,
      'isOnline': isOnline,
    };
  }
}
