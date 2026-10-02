import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/domain/comments/repositories/get_comments_repository.dart';

class GetCommentsUseCase {
  final GetCommentsRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<Comment>> call() async {
    return await repository.getComments();
  }
}
