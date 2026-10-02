import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/domain/comments/repositories/create_comment_repository.dart';

class CreateCommentUseCase {
  final CreateCommentRepository repository;

  CreateCommentUseCase(this.repository);

  Future<Comment> call({required String content, int postId = 1}) async {
    return await repository.createComment(content: content, postId: postId);
  }
}
