import 'package:manage_state/data/friends/datasources/friends_remote_datasource.dart';
import 'package:manage_state/domain/friends/entities/friend_request.dart';
import 'package:manage_state/domain/friends/repositories/friends_repository.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDataSource remoteDataSource;

  FriendsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FriendRequest>> getFriendRequests() async {
    try {
      final models = await remoteDataSource.getFriendRequests();
      return models;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
