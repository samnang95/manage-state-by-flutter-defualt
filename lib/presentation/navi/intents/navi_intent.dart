import 'package:flutter/widgets.dart';

sealed class NaviIntent {
  const NaviIntent();
}

class ChangeNaviTabIntent extends NaviIntent {
  final int index;
  const ChangeNaviTabIntent(this.index);
}

class NaviScrollNotificationIntent extends NaviIntent {
  final UserScrollNotification notification;
  const NaviScrollNotificationIntent(this.notification);
}
