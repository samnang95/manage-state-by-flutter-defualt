import 'package:manage_state/domain/friends/entities/friend_request.dart';
import 'package:manage_state/domain/friends/repositories/friends_repository.dart';

class GetFriendRequestsUseCase {
  final FriendsRepository repository;

  GetFriendRequestsUseCase(this.repository);

  Future<List<FriendRequest>> call() {
    return repository.getFriendRequests();
  }
}
