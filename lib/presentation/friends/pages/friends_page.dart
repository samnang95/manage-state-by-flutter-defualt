import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/friends/controllers/friends_controller.dart';
import 'package:manage_state/presentation/friends/widgets/friends_filter_chips.dart';
import 'package:manage_state/presentation/friends/widgets/friends_requests_header.dart';
import 'package:manage_state/presentation/friends/widgets/friend_request_card.dart';

class FriendsPage extends StatelessWidget {
  FriendsPage({super.key});

  final FriendsController _controller = DependencyInjector.instance.getFriendsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.white,
              onRefresh: _controller.refreshData,
              child: CustomScrollView(
                slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.white,
                  surfaceTintColor: AppColors.white,
                  scrolledUnderElevation: 0,
                  floating: true,
                  snap: true,
                  elevation: 0,
                  toolbarHeight: 40,
                  titleSpacing: 16,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.menu,
                            color: AppColors.black,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Friends',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.search,
                          color: AppColors.black,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter chips
                      FriendsFilterChips(
                        filters: _controller.filters,
                        selectedFilterIndex: _controller.selectedFilterIndex,
                        onFilterTap: _controller.selectFilter,
                      ),
                      const Divider(height: 1, color: AppColors.grey300),
                      // Friend Requests header
                      FriendsRequestsHeader(
                        requestCount: _controller.requestCount,
                      ),
                    ],
                  ),
                ),
                // Friend request list
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FriendRequestCard(
                        request: _controller.friendRequests[index],
                        onConfirm: () => _controller.confirmRequest(index),
                        onDelete: () => _controller.deleteRequest(index),
                      ),
                    );
                  }, childCount: _controller.friendRequests.length),
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
