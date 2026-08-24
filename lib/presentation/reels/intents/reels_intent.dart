sealed class ReelsIntent {
  const ReelsIntent();
}

class LoadReelsIntent extends ReelsIntent {
  const LoadReelsIntent();
}

class RefreshReelsIntent extends ReelsIntent {
  const RefreshReelsIntent();
}

class ChangeReelPageIntent extends ReelsIntent {
  final int index;
  const ChangeReelPageIntent(this.index);
}
