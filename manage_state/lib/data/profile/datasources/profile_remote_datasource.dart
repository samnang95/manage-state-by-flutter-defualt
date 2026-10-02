import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';
import 'package:manage_state/data/profile/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserProfileModel> getUserProfile() async {
    final response = await apiClient.get(ApiEndpoints.profile);

    if (response is Map<String, dynamic>) {
      return UserProfileModel.fromJson(response);
    }

    throw ApiException(
      statusCode: 500,
      message: 'Invalid profile response from server',
    );
  }
}
