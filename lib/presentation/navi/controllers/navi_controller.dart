import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NaviController extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isBottomNavVisible = true;

  final ScrollController homeScrollController = ScrollController();

  int get currentIndex => _currentIndex;
  bool get isBottomNavVisible => _isBottomNavVisible;

  void changeTab(int index) {
    // If user clicks Home while already on Home, scroll to top
    if (index == 0 && _currentIndex == 0) {
      if (homeScrollController.hasClients) {
        homeScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }

    _currentIndex = index;
    _isBottomNavVisible = true;
    notifyListeners();
  }

  void onScroll(UserScrollNotification notification) {
    if (_currentIndex != 0) return;

    if (notification.direction == ScrollDirection.reverse &&
        _isBottomNavVisible) {
      _isBottomNavVisible = false;
      notifyListeners();
    } else if (notification.direction == ScrollDirection.forward &&
        !_isBottomNavVisible) {
      _isBottomNavVisible = true;
      notifyListeners();
    }
  }
}
