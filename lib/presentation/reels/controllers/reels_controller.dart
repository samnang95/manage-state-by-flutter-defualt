import 'package:flutter/material.dart';
import 'package:manage_state/domain/reels/entities/reel_item.dart';
import 'package:manage_state/domain/reels/usecases/get_reels_usecase.dart';

class ReelsController extends ChangeNotifier {
  final GetReelsUseCase getReelsUseCase;

  ReelsController({required this.getReelsUseCase}) {
    _loadData();
  }

  List<ReelItem> reels = [];
  bool isLoading = true;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      reels = await getReelsUseCase();
    } catch (e) {
      debugPrint('Error loading reels: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> refreshData() async {
    try {
      reels = await getReelsUseCase();
    } catch (e) {
      debugPrint('Error refreshing reels: $e');
    }
    notifyListeners();
  }
}
