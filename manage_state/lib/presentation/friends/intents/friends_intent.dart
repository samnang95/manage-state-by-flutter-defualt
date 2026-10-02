sealed class FriendsIntent {
  const FriendsIntent();
}

class LoadFriendsIntent extends FriendsIntent {
  const LoadFriendsIntent();
}

class RefreshFriendsIntent extends FriendsIntent {
  const RefreshFriendsIntent();
}

class SelectFriendsFilterIntent extends FriendsIntent {
  final int index;
  const SelectFriendsFilterIntent(this.index);
}

class ConfirmFriendRequestIntent extends FriendsIntent {
  final int index;
  const ConfirmFriendRequestIntent(this.index);
}

class DeleteFriendRequestIntent extends FriendsIntent {
  final int index;
  const DeleteFriendRequestIntent(this.index);
}
