sealed class ProfileIntent {
  const ProfileIntent();
}

class LoadProfileIntent extends ProfileIntent {
  const LoadProfileIntent();
}

class RefreshProfileIntent extends ProfileIntent {
  const RefreshProfileIntent();
}

class ChangeProfileTabIntent extends ProfileIntent {
  final int index;
  const ChangeProfileTabIntent(this.index);
}
