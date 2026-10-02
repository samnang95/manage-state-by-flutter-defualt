import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';

abstract class DeleteCommentRemoteDataSource {
  Future<void> deleteComment(int id);
}

class DeleteCommentRemoteDataSourceImpl implements DeleteCommentRemoteDataSource {
  final ApiClient apiClient;

  DeleteCommentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<void> deleteComment(int id) async {
    await apiClient.delete('${ApiEndpoints.comments}/$id');
  }
}
