import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/home/usecases/get_posts_usecase.dart';
import 'package:manage_state/domain/home/usecases/get_stories_usecase.dart';
import 'package:manage_state/presentation/home/intents/home_intent.dart';
import 'package:manage_state/presentation/home/states/home_state.dart';

class HomeController extends MviController<HomeIntent, HomeState> {
  final GetStoriesUseCase getStoriesUseCase;
  final GetPostsUseCase getPostsUseCase;

  HomeController({
    required this.getStoriesUseCase,
    required this.getPostsUseCase,
  }) : super(const HomeState()) {
    onIntent(const LoadHomeDataIntent());
  }

  @override
  void onIntent(HomeIntent intent) {
    switch (intent) {
      case LoadHomeDataIntent():
        _handleLoadData();
      case RefreshHomeDataIntent():
        _handleRefreshData();
      case TogglePostLikeIntent(:final postIndex):
        _handleToggleLike(postIndex);
    }
  }

  Future<void> _handleLoadData() async {
    emit(value.copyWith(isLoading: true, errorMessage: null));

    try {
      final stories = await getStoriesUseCase();
      final posts = await getPostsUseCase();
      emit(value.copyWith(
        isLoading: false,
        stories: stories,
        posts: posts,
      ));
    } catch (e) {
      debugPrint('Error loading home data: $e');
      emit(value.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _handleRefreshData() async {
    try {
      final stories = await getStoriesUseCase();
      final posts = await getPostsUseCase();
      emit(value.copyWith(
        stories: stories,
        posts: posts,
      ));
    } catch (e) {
      debugPrint('Error refreshing home data: $e');
    }
  }

  void _handleToggleLike(int postIndex) {
    if (postIndex < 0 || postIndex >= value.posts.length) return;

    final updatedPosts = List.of(value.posts);
    final post = updatedPosts[postIndex];
    final isLiked = !post.isLiked;
    final likes = isLiked ? post.likes + 1 : post.likes - 1;

    // Mutate or update post instance
    post.isLiked = isLiked;
    post.likes = likes;

    emit(value.copyWith(posts: updatedPosts));
  }
}
