import 'package:flutter/material.dart';
import 'package:manage_state/domain/profile/entities/user_profile.dart';
import 'package:manage_state/domain/profile/usecases/get_user_profile_usecase.dart';

class ProfileController extends ChangeNotifier {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileController({required this.getUserProfileUseCase}) {
    _loadData();
  }

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void changeTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  UserProfile? userProfile;
  bool isLoading = true;

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      userProfile = await getUserProfileUseCase();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    try {
      userProfile = await getUserProfileUseCase();
    } catch (e) {
      debugPrint('Error refreshing profile: $e');
    }
    notifyListeners();
  }
}