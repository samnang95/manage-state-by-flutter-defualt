import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/profile/usecases/get_user_profile_usecase.dart';
import 'package:manage_state/presentation/profile/intents/profile_intent.dart';
import 'package:manage_state/presentation/profile/states/profile_state.dart';

class ProfileController extends MviController<ProfileIntent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileController({required this.getUserProfileUseCase})
      : super(const ProfileState()) {
    onIntent(const LoadProfileIntent());
  }

  @override
  void onIntent(ProfileIntent intent) {
    switch (intent) {
      case LoadProfileIntent():
        _handleLoadProfile();
      case RefreshProfileIntent():
        _handleRefreshProfile();
      case ChangeProfileTabIntent(:final index):
        _handleChangeTab(index);
    }
  }

  Future<void> _handleLoadProfile() async {
    emit(value.copyWith(isLoading: true, errorMessage: null));

    try {
      final profile = await getUserProfileUseCase();
      emit(value.copyWith(isLoading: false, userProfile: profile));
    } catch (e) {
      debugPrint('Error loading profile: $e');
      emit(value.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _handleRefreshProfile() async {
    try {
      final profile = await getUserProfileUseCase();
      emit(value.copyWith(userProfile: profile));
    } catch (e) {
      debugPrint('Error refreshing profile: $e');
    }
  }

  void _handleChangeTab(int index) {
    emit(value.copyWith(selectedTabIndex: index));
  }
}