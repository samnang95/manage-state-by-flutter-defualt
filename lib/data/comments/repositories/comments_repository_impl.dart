import 'package:manage_state/data/comments/datasources/comments_remote_datasource.dart';
import 'package:manage_state/data/comments/models/comment_model.dart';
import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/domain/comments/repositories/comments_repository.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final CommentsRemoteDataSource remoteDataSource;

  CommentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Comment>> getComments() async {
    final commentsList = await remoteDataSource.getComments();
    return commentsList
        .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
