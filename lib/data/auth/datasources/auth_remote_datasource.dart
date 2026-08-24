import 'package:manage_state/core/network/api_client.dart';

import 'package:manage_state/data/auth/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (email == 'test@test.com' && password == '123456') {
      if (apiClient.tokenManager != null) {
        await apiClient.tokenManager!.saveTokens(
          accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
          refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        );
      }
      return UserModel(id: '1', email: email, name: 'Test User');
    } else {
      throw Exception('Invalid email or password');
    }
  }
}
