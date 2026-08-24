import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/presentation/navi/intents/navi_intent.dart';
import 'package:manage_state/presentation/navi/states/navi_state.dart';

class NaviController extends MviController<NaviIntent, NaviState> {
  final ScrollController homeScrollController = ScrollController();

  NaviController() : super(const NaviState());

  @override
  void onIntent(NaviIntent intent) {
    switch (intent) {
      case ChangeNaviTabIntent(:final index):
        _handleChangeTab(index);
      case NaviScrollNotificationIntent(:final notification):
        _handleScrollNotification(notification);
    }
  }

  void _handleChangeTab(int index) {
    // If user clicks Home while already on Home, scroll to top
    if (index == 0 && value.currentIndex == 0) {
      if (homeScrollController.hasClients) {
        homeScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }

    emit(value.copyWith(
      currentIndex: index,
      isBottomNavVisible: true,
    ));
  }

  void _handleScrollNotification(UserScrollNotification notification) {
    if (value.currentIndex != 0) return;

    if (notification.direction == ScrollDirection.reverse &&
        value.isBottomNavVisible) {
      emit(value.copyWith(isBottomNavVisible: false));
    } else if (notification.direction == ScrollDirection.forward &&
        !value.isBottomNavVisible) {
      emit(value.copyWith(isBottomNavVisible: true));
    }
  }

  @override
  void dispose() {
    homeScrollController.dispose();
    super.dispose();
  }
}
