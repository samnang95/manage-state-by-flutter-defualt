import 'package:manage_state/domain/profile/entities/user_profile.dart';

class ProfileState {
  final bool isLoading;
  final UserProfile? userProfile;
  final int selectedTabIndex;
  final String? errorMessage;

  const ProfileState({
    this.isLoading = true,
    this.userProfile,
    this.selectedTabIndex = 0,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? userProfile,
    int? selectedTabIndex,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userProfile: userProfile ?? this.userProfile,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      errorMessage: errorMessage,
    );
  }
}
