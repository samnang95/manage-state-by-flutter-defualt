import 'package:flutter/material.dart';
import 'package:manage_state/domain/home/entities/story.dart';
import 'package:manage_state/domain/home/entities/post.dart';
import 'package:manage_state/domain/home/usecases/get_stories_usecase.dart';
import 'package:manage_state/domain/home/usecases/get_posts_usecase.dart';

class HomeController extends ChangeNotifier {
  final GetStoriesUseCase getStoriesUseCase;
  final GetPostsUseCase getPostsUseCase;

  HomeController({
    required this.getStoriesUseCase,
    required this.getPostsUseCase,
  }) {
    _loadData();
  }

  List<Story> stories = [];
  List<Post> posts = [];
  bool isLoading = true;

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      stories = await getStoriesUseCase();
      posts = await getPostsUseCase();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleLike(int postIndex) {
    final post = posts[postIndex];
    post.isLiked = !post.isLiked;

    if (post.isLiked) {
      post.likes++;
    } else {
      post.likes--;
    }

    notifyListeners();
  }

  Future<void> refreshData() async {
    try {
      stories = await getStoriesUseCase();
      posts = await getPostsUseCase();
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    }
    notifyListeners();
  }
}
