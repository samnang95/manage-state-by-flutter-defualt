import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/notifications/controllers/notifications_controller.dart';
import 'package:manage_state/presentation/notifications/intents/notifications_intent.dart';
import 'package:manage_state/presentation/notifications/states/notifications_state.dart';
import 'package:manage_state/presentation/notifications/widgets/notification_tile.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final NotificationsController _controller = DependencyInjector.instance.getNotificationsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ValueListenableBuilder<NotificationsState>(
          valueListenable: _controller,
          builder: (context, state, _) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _controller.onIntent(const RefreshNotificationsIntent());
              },
              color: AppColors.primary,
              child: CustomScrollView(
                slivers: [
                  // App bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.menu,
                                  color: AppColors.black,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.search,
                              color: AppColors.black,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // "New" section header
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 4,
                        bottom: 8,
                      ),
                      child: Text(
                        'New',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  // New notifications list
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.newNotifications[index];
                        return NotificationTile(
                          notification: item,
                          onTap: () {
                            _controller.onIntent(MarkNotificationAsReadIntent(item.id));
                          },
                          onToggleRead: () {
                            _controller.onIntent(ToggleNotificationReadIntent(item.id));
                          },
                        );
                      },
                      childCount: state.newNotifications.length,
                    ),
                  ),
                  // Divider
                  const SliverToBoxAdapter(
                    child: Divider(
                      color: AppColors.grey300,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ),
                  // "Today" section header
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                        bottom: 8,
                      ),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  // Today notifications list
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.todayNotifications[index];
                        return NotificationTile(
                          notification: item,
                          onTap: () {
                            _controller.onIntent(MarkNotificationAsReadIntent(item.id));
                          },
                          onToggleRead: () {
                            _controller.onIntent(ToggleNotificationReadIntent(item.id));
                          },
                        );
                      },
                      childCount: state.todayNotifications.length,
                    ),
                  ),
                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
