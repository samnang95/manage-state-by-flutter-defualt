import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/friends/usecases/get_friend_requests_usecase.dart';
import 'package:manage_state/presentation/friends/intents/friends_intent.dart';
import 'package:manage_state/presentation/friends/states/friends_state.dart';

class FriendsController extends MviController<FriendsIntent, FriendsState> {
  final GetFriendRequestsUseCase getFriendRequestsUseCase;

  FriendsController({required this.getFriendRequestsUseCase})
      : super(const FriendsState()) {
    onIntent(const LoadFriendsIntent());
  }

  @override
  void onIntent(FriendsIntent intent) {
    switch (intent) {
      case LoadFriendsIntent():
        _handleLoadData();
      case RefreshFriendsIntent():
        _handleRefreshData();
      case SelectFriendsFilterIntent(:final index):
        _handleSelectFilter(index);
      case ConfirmFriendRequestIntent(:final index):
        _handleRemoveRequest(index);
      case DeleteFriendRequestIntent(:final index):
        _handleRemoveRequest(index);
    }
  }

  Future<void> _handleLoadData() async {
    emit(value.copyWith(isLoading: true, errorMessage: null));

    try {
      final requests = await getFriendRequestsUseCase();
      emit(value.copyWith(
        isLoading: false,
        friendRequests: requests,
      ));
    } catch (e) {
      debugPrint('Error loading friend requests: $e');
      emit(value.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _handleRefreshData() async {
    try {
      final requests = await getFriendRequestsUseCase();
      emit(value.copyWith(friendRequests: requests));
    } catch (e) {
      debugPrint('Error refreshing friend requests: $e');
    }
  }

  void _handleSelectFilter(int index) {
    final newIndex = value.selectedFilterIndex == index ? -1 : index;
    emit(value.copyWith(selectedFilterIndex: newIndex));
  }

  void _handleRemoveRequest(int index) {
    if (index < 0 || index >= value.friendRequests.length) return;

    final updated = List.of(value.friendRequests)..removeAt(index);
    emit(value.copyWith(friendRequests: updated));
  }
}
