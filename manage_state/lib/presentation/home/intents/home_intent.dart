sealed class HomeIntent {
  const HomeIntent();
}

class LoadHomeDataIntent extends HomeIntent {
  const LoadHomeDataIntent();
}

class RefreshHomeDataIntent extends HomeIntent {
  const RefreshHomeDataIntent();
}

class TogglePostLikeIntent extends HomeIntent {
  final int postIndex;
  const TogglePostLikeIntent(this.postIndex);
}
