import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/presentation/navi/controllers/navi_controller.dart';
import 'package:manage_state/presentation/navi/intents/navi_intent.dart';
import 'package:manage_state/presentation/navi/states/navi_state.dart';
import 'package:manage_state/presentation/navi/widgets/nav_item.dart';
import 'package:manage_state/presentation/navi/widgets/profile_nav_item.dart';
import 'package:manage_state/presentation/home/pages/home_page.dart';
import 'package:manage_state/presentation/reels/pages/reels_page.dart';
import 'package:manage_state/presentation/friends/pages/friends_page.dart';
import 'package:manage_state/presentation/marketplace/pages/marketplace_page.dart';
import 'package:manage_state/presentation/notifications/pages/notifications_page.dart';
import 'package:manage_state/presentation/profile/pages/profile_page.dart';

class NaviPage extends StatelessWidget {
  NaviPage({super.key});

  final NaviController _controller = NaviController();

  late final List<Widget> _pages = [
    HomePage(scrollController: _controller.homeScrollController),
    ReelsPage(),
    FriendsPage(),
    MarketplacePage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NaviState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        final bool isReelsTab = state.currentIndex == 1;

        return Scaffold(
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              _controller.onIntent(NaviScrollNotificationIntent(notification));
              return false;
            },
            child: IndexedStack(
              index: state.currentIndex,
              children: _pages,
            ),
          ),
          bottomNavigationBar: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizedBox(
              height: state.isBottomNavVisible ? null : 0.0,
              child: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isReelsTab ? AppColors.black : AppColors.white,
                      border: Border(
                        top: BorderSide(
                          color: isReelsTab ? AppColors.black : AppColors.grey300, 
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NavItem(
                              isSelected: state.currentIndex == 0,
                              icon: Icons.home_outlined,
                              activeIcon: Icons.home,
                              isDark: isReelsTab,
                              onTap: () {
                                _controller.onIntent(const ChangeNaviTabIntent(0));
                              },
                            ),
                            NavItem(
                              isSelected: state.currentIndex == 1,
                              icon: Icons.ondemand_video_outlined,
                              activeIcon: Icons.ondemand_video,
                              isDark: isReelsTab,
                              onTap: () {
                                _controller.onIntent(const ChangeNaviTabIntent(1));
                              },
                            ),
                            NavItem(
                              isSelected: state.currentIndex == 2,
                              icon: Icons.people_outline,
                              activeIcon: Icons.people,
                              isDark: isReelsTab,
                              onTap: () {
                                _controller.onIntent(const ChangeNaviTabIntent(2));
                              },
                            ),
                            NavItem(
                              isSelected: state.currentIndex == 3,
                              icon: Icons.storefront_outlined,
                              activeIcon: Icons.storefront,
                              isDark: isReelsTab,
                              onTap: () {
                                _controller.onIntent(const ChangeNaviTabIntent(3));
                              },
                            ),
                            NavItem(
                              isSelected: state.currentIndex == 4,
                              icon: Icons.notifications_outlined,
                              activeIcon: Icons.notifications,
                              isDark: isReelsTab,
                              onTap: () {
                                _controller.onIntent(const ChangeNaviTabIntent(4));
                              },
                            ),
                            ProfileNavItem(
                              isSelected: state.currentIndex == 5,
                              avatarUrl: 'https://i.pravatar.cc/150?img=3',
                              isDark: isReelsTab,
                              onTap: () {
                                _controller.onIntent(const ChangeNaviTabIntent(5));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
