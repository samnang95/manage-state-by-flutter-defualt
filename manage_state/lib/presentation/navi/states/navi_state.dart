class NaviState {
  final int currentIndex;
  final bool isBottomNavVisible;

  const NaviState({
    this.currentIndex = 0,
    this.isBottomNavVisible = true,
  });

  NaviState copyWith({
    int? currentIndex,
    bool? isBottomNavVisible,
  }) {
    return NaviState(
      currentIndex: currentIndex ?? this.currentIndex,
      isBottomNavVisible: isBottomNavVisible ?? this.isBottomNavVisible,
    );
  }
}
