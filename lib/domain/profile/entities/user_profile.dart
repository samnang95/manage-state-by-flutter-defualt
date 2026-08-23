class UserProfile {
  final String name;
  final String avatarUrl;
  final String coverPhotoUrl;
  final int friendsCount;
  final int postsCount;
  
  // Personal details
  final String location;
  final String hometown;
  final String birthday;
  final String relationshipStatus;
  final String gender;

  UserProfile({
    required this.name,
    required this.avatarUrl,
    required this.coverPhotoUrl,
    required this.friendsCount,
    required this.postsCount,
    required this.location,
    required this.hometown,
    required this.birthday,
    required this.relationshipStatus,
    required this.gender,
  });
}
