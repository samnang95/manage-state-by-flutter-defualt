import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';

abstract class CreateCommentRemoteDataSource {
  Future<Map<String, dynamic>> createComment({
    required String content,
    int postId = 1,
  });
}

class CreateCommentRemoteDataSourceImpl implements CreateCommentRemoteDataSource {
  final ApiClient apiClient;

  CreateCommentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> createComment({
    required String content,
    int postId = 1,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.comments,
      body: {'body': content, 'postId': postId},
    );
    return response as Map<String, dynamic>;
  }
}
