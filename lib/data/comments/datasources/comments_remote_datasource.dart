import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';

abstract class CommentsRemoteDataSource {
  Future<List<dynamic>> getComments();
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  final ApiClient apiClient;

  CommentsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<dynamic>> getComments() async {
    // Calling the endpoint constant
    final response = await apiClient.get(ApiEndpoints.comments);
    
    // dummyjson wraps the array in a "comments" key
    if (response is Map<String, dynamic> && response.containsKey('comments')) {
      return response['comments'] as List<dynamic>;
    }
    return [];
  }
}
