import 'package:manage_state/domain/comments/repositories/delete_comment_repository.dart';

class DeleteCommentUseCase {
  final DeleteCommentRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteComment(id);
  }
}
