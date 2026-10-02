import 'package:manage_state/domain/friends/entities/friend_request.dart';

class FriendsState {
  final bool isLoading;
  final List<String> filters;
  final int selectedFilterIndex;
  final List<FriendRequest> friendRequests;
  final String? errorMessage;

  const FriendsState({
    this.isLoading = true,
    this.filters = const ['128 online', 'Suggestions', 'Your friends'],
    this.selectedFilterIndex = -1,
    this.friendRequests = const [],
    this.errorMessage,
  });

  int get requestCount => friendRequests.length;

  FriendsState copyWith({
    bool? isLoading,
    List<String>? filters,
    int? selectedFilterIndex,
    List<FriendRequest>? friendRequests,
    String? errorMessage,
  }) {
    return FriendsState(
      isLoading: isLoading ?? this.isLoading,
      filters: filters ?? this.filters,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      friendRequests: friendRequests ?? this.friendRequests,
      errorMessage: errorMessage,
    );
  }
}
