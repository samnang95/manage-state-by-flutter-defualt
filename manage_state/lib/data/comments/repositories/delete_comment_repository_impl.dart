import 'package:manage_state/data/comments/datasources/delete_comment_remote_datasource.dart';
import 'package:manage_state/domain/comments/repositories/delete_comment_repository.dart';

class DeleteCommentRepositoryImpl implements DeleteCommentRepository {
  final DeleteCommentRemoteDataSource remoteDataSource;

  DeleteCommentRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> deleteComment(int id) async {
    await remoteDataSource.deleteComment(id);
  }
}
