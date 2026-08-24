import 'package:manage_state/domain/reels/entities/reel_item.dart';

class ReelsState {
  final bool isLoading;
  final List<ReelItem> reels;
  final int currentIndex;
  final String? errorMessage;

  const ReelsState({
    this.isLoading = true,
    this.reels = const [],
    this.currentIndex = 0,
    this.errorMessage,
  });

  ReelsState copyWith({
    bool? isLoading,
    List<ReelItem>? reels,
    int? currentIndex,
    String? errorMessage,
  }) {
    return ReelsState(
      isLoading: isLoading ?? this.isLoading,
      reels: reels ?? this.reels,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage,
    );
  }
}
