import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';
import 'package:manage_state/data/auth/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );

    if (response is Map<String, dynamic>) {
      if (apiClient.tokenManager != null &&
          response['accessToken'] != null &&
          response['refreshToken'] != null) {
        await apiClient.tokenManager!.saveTokens(
          accessToken: response['accessToken'].toString(),
          refreshToken: response['refreshToken'].toString(),
        );
      }

      if (response['user'] is Map<String, dynamic>) {
        return UserModel.fromJson(response['user'] as Map<String, dynamic>);
      }
    }

    throw ApiException(
      statusCode: 500,
      message: 'Invalid response from authentication server',
    );
  }
}
