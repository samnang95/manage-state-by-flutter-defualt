import 'package:flutter/material.dart';
import 'package:manage_state/domain/friends/entities/friend_request.dart';
import 'package:manage_state/domain/friends/usecases/get_friend_requests_usecase.dart';

class FriendsController extends ChangeNotifier {
  final GetFriendRequestsUseCase getFriendRequestsUseCase;

  FriendsController({required this.getFriendRequestsUseCase}) {
    _loadData();
  }

  // Filter chips
  final List<String> filters = ['128 online', 'Suggestions', 'Your friends'];
  int selectedFilterIndex = -1;

  void selectFilter(int index) {
    selectedFilterIndex = selectedFilterIndex == index ? -1 : index;
    notifyListeners();
  }

  // Friend requests
  List<FriendRequest> friendRequests = [];
  bool isLoading = true;

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      friendRequests = await getFriendRequestsUseCase();
    } catch (e) {
      debugPrint('Error loading friend requests: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  int get requestCount => friendRequests.length;

  void confirmRequest(int index) {
    friendRequests.removeAt(index);
    notifyListeners();
  }

  void deleteRequest(int index) {
    friendRequests.removeAt(index);
    notifyListeners();
  }

  Future<void> refreshData() async {
    try {
      friendRequests = await getFriendRequestsUseCase();
    } catch (e) {
      debugPrint('Error refreshing friend requests: $e');
    }
    notifyListeners();
  }
}
