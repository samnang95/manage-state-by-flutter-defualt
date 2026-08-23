import 'package:manage_state/domain/friends/entities/friend_request.dart';

abstract class FriendsRepository {
  Future<List<FriendRequest>> getFriendRequests();
}
