import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/domain/comments/repositories/update_comment_repository.dart';

class UpdateCommentUseCase {
  final UpdateCommentRepository repository;

  UpdateCommentUseCase(this.repository);

  Future<Comment> call({required int id, required String content}) async {
    return await repository.updateComment(id: id, content: content);
  }
}
