import 'package:manage_state/domain/home/entities/post.dart';
import 'package:manage_state/domain/home/entities/story.dart';

class HomeState {
  final bool isLoading;
  final List<Story> stories;
  final List<Post> posts;
  final String? errorMessage;

  const HomeState({
    this.isLoading = true,
    this.stories = const [],
    this.posts = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Story>? stories,
    List<Post>? posts,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
    );
  }
}
