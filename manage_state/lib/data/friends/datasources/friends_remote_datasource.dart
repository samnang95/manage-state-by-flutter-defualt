import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';
import 'package:manage_state/data/friends/models/friend_request_model.dart';

abstract class FriendsRemoteDataSource {
  Future<List<FriendRequestModel>> getFriendRequests();
}

class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  final ApiClient apiClient;

  FriendsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<FriendRequestModel>> getFriendRequests() async {
    final response = await apiClient.get(ApiEndpoints.friendRequests);

    if (response is List) {
      return response
          .map((json) => FriendRequestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
