import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/friends/controllers/friends_controller.dart';
import 'package:manage_state/presentation/friends/intents/friends_intent.dart';
import 'package:manage_state/presentation/friends/states/friends_state.dart';
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
        child: ValueListenableBuilder<FriendsState>(
          valueListenable: _controller,
          builder: (context, state, _) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.white,
              onRefresh: () async {
                _controller.onIntent(const RefreshFriendsIntent());
              },
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
                          filters: state.filters,
                          selectedFilterIndex: state.selectedFilterIndex,
                          onFilterTap: (index) {
                            _controller.onIntent(SelectFriendsFilterIntent(index));
                          },
                        ),
                        const Divider(height: 1, color: AppColors.grey300),
                        // Friend Requests header
                        FriendsRequestsHeader(
                          requestCount: state.requestCount,
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
                          request: state.friendRequests[index],
                          onConfirm: () {
                            _controller.onIntent(ConfirmFriendRequestIntent(index));
                          },
                          onDelete: () {
                            _controller.onIntent(DeleteFriendRequestIntent(index));
                          },
                        ),
                      );
                    }, childCount: state.friendRequests.length),
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
