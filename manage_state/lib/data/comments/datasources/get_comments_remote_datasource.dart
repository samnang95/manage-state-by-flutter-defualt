import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';

abstract class GetCommentsRemoteDataSource {
  Future<List<dynamic>> getComments();
}

class GetCommentsRemoteDataSourceImpl implements GetCommentsRemoteDataSource {
  final ApiClient apiClient;

  GetCommentsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<dynamic>> getComments() async {
    final response = await apiClient.get(ApiEndpoints.comments);

    if (response is Map<String, dynamic> && response.containsKey('comments')) {
      return response['comments'] as List<dynamic>;
    }
    if (response is List) {
      return response;
    }
    return [];
  }
}
