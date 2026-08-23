import 'package:manage_state/domain/home/entities/story.dart';
import 'package:manage_state/domain/home/entities/post.dart';

abstract class HomeRepository {
  Future<List<Story>> getStories();
  Future<List<Post>> getPosts();
}
