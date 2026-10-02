import 'package:manage_state/domain/comments/entities/comment.dart';

abstract class CreateCommentRepository {
  Future<Comment> createComment({required String content, int postId = 1});
}
