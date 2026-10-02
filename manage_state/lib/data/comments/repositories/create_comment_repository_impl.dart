import 'package:manage_state/data/comments/datasources/create_comment_remote_datasource.dart';
import 'package:manage_state/data/comments/models/comment_model.dart';
import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/domain/comments/repositories/create_comment_repository.dart';

class CreateCommentRepositoryImpl implements CreateCommentRepository {
  final CreateCommentRemoteDataSource remoteDataSource;

  CreateCommentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Comment> createComment({required String content, int postId = 1}) async {
    final json = await remoteDataSource.createComment(content: content, postId: postId);
    return CommentModel.fromJson(json);
  }
}
