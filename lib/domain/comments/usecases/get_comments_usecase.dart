import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/domain/comments/repositories/comments_repository.dart';

class GetCommentsUseCase {
  final CommentsRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<Comment>> call() async {
    return await repository.getComments();
  }
}
