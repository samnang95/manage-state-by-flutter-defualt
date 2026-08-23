class FriendRequest {
  final String name;
  final String avatar;
  final int mutualFriends;
  final List<String> mutualAvatars;
  final String timeAgo;
  final bool isOnline;

  FriendRequest({
    required this.name,
    required this.avatar,
    required this.mutualFriends,
    required this.mutualAvatars,
    required this.timeAgo,
    required this.isOnline,
  });
}
