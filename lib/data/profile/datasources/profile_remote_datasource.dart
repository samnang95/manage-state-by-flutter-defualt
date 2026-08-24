import 'package:manage_state/core/network/api_client.dart';

import 'package:manage_state/data/profile/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return UserProfileModel.fromJson({
      'name': 'វិន សំណាង',
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'coverPhotoUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
      'friendsCount': 878,
      'postsCount': 9,
      'location': 'Phnom Penh',
      'hometown': 'Poipet',
      'birthday': '23 July 2003',
      'relationshipStatus': 'Single',
      'gender': 'Male',
    });
  }
}
