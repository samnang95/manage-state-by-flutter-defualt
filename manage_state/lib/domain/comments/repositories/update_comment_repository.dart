import 'package:manage_state/domain/comments/entities/comment.dart';

abstract class UpdateCommentRepository {
  Future<Comment> updateComment({required int id, required String content});
}
