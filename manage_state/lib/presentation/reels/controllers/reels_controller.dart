import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/reels/usecases/get_reels_usecase.dart';
import 'package:manage_state/presentation/reels/intents/reels_intent.dart';
import 'package:manage_state/presentation/reels/states/reels_state.dart';

class ReelsController extends MviController<ReelsIntent, ReelsState> {
  final GetReelsUseCase getReelsUseCase;

  ReelsController({required this.getReelsUseCase})
      : super(const ReelsState()) {
    onIntent(const LoadReelsIntent());
  }

  @override
  void onIntent(ReelsIntent intent) {
    switch (intent) {
      case LoadReelsIntent():
        _handleLoadData();
      case RefreshReelsIntent():
        _handleRefreshData();
      case ChangeReelPageIntent(:final index):
        _handleChangePage(index);
    }
  }

  Future<void> _handleLoadData() async {
    emit(value.copyWith(isLoading: true, errorMessage: null));

    try {
      final reels = await getReelsUseCase();
      emit(value.copyWith(isLoading: false, reels: reels));
    } catch (e) {
      debugPrint('Error loading reels: $e');
      emit(value.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _handleRefreshData() async {
    try {
      final reels = await getReelsUseCase();
      emit(value.copyWith(reels: reels));
    } catch (e) {
      debugPrint('Error refreshing reels: $e');
    }
  }

  void _handleChangePage(int index) {
    emit(value.copyWith(currentIndex: index));
  }
}
