import 'package:manage_state/data/home/datasources/home_remote_datasource.dart';
import 'package:manage_state/domain/home/entities/story.dart';
import 'package:manage_state/domain/home/entities/post.dart';
import 'package:manage_state/domain/home/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Story>> getStories() async {
    try {
      final storyModels = await remoteDataSource.getStories();
      return storyModels;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Post>> getPosts() async {
    try {
      final postModels = await remoteDataSource.getPosts();
      return postModels;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
