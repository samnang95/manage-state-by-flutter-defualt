import 'package:manage_state/domain/home/entities/post.dart';
import 'package:manage_state/domain/home/repositories/home_repository.dart';

class GetPostsUseCase {
  final HomeRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<Post>> call() {
    return repository.getPosts();
  }
}
