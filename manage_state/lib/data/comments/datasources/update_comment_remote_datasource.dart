import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';

abstract class UpdateCommentRemoteDataSource {
  Future<Map<String, dynamic>> updateComment({
    required int id,
    required String content,
  });
}

class UpdateCommentRemoteDataSourceImpl implements UpdateCommentRemoteDataSource {
  final ApiClient apiClient;

  UpdateCommentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> updateComment({
    required int id,
    required String content,
  }) async {
    final response = await apiClient.put(
      '${ApiEndpoints.comments}/$id',
      body: {'body': content},
    );
    return response as Map<String, dynamic>;
  }
}
