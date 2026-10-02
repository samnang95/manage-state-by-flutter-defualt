import 'package:manage_state/data/comments/datasources/update_comment_remote_datasource.dart';
import 'package:manage_state/data/comments/models/comment_model.dart';
import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/domain/comments/repositories/update_comment_repository.dart';

class UpdateCommentRepositoryImpl implements UpdateCommentRepository {
  final UpdateCommentRemoteDataSource remoteDataSource;

  UpdateCommentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Comment> updateComment({required int id, required String content}) async {
    final json = await remoteDataSource.updateComment(id: id, content: content);
    return CommentModel.fromJson(json);
  }
}
