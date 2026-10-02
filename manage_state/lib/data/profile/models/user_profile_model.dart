import 'package:manage_state/domain/profile/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.name,
    required super.avatarUrl,
    required super.coverPhotoUrl,
    required super.friendsCount,
    required super.postsCount,
    required super.location,
    required super.hometown,
    required super.birthday,
    required super.relationshipStatus,
    required super.gender,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      coverPhotoUrl: json['coverPhotoUrl'],
      friendsCount: json['friendsCount'],
      postsCount: json['postsCount'],
      location: json['location'],
      hometown: json['hometown'],
      birthday: json['birthday'],
      relationshipStatus: json['relationshipStatus'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'friendsCount': friendsCount,
      'postsCount': postsCount,
      'location': location,
      'hometown': hometown,
      'birthday': birthday,
      'relationshipStatus': relationshipStatus,
      'gender': gender,
    };
  }
}
