import 'package:manage_state/domain/home/entities/story.dart';
import 'package:manage_state/domain/home/repositories/home_repository.dart';

class GetStoriesUseCase {
  final HomeRepository repository;

  GetStoriesUseCase(this.repository);

  Future<List<Story>> call() {
    return repository.getStories();
  }
}