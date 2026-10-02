import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';
import 'package:manage_state/data/home/models/story_model.dart';
import 'package:manage_state/data/home/models/post_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<List<PostModel>> getPosts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<StoryModel>> getStories() async {
    final response = await apiClient.get(ApiEndpoints.stories);

    if (response is List) {
      return response
          .map((json) => StoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await apiClient.get(ApiEndpoints.homeFeed);

    if (response is List) {
      return response
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
