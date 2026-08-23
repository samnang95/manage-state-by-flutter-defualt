import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/home/controllers/home_controller.dart';
import 'package:manage_state/presentation/home/widgets/create_post_section.dart';
import 'package:manage_state/presentation/home/widgets/stories_section.dart';
import 'package:manage_state/presentation/home/widgets/post_item.dart';

class HomePage extends StatelessWidget {
  final ScrollController? scrollController;

  HomePage({super.key, this.scrollController});

  final HomeController _controller = DependencyInjector.instance.getHomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Container(
          color: AppColors.neutral,
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
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.white,
                      surfaceTintColor: AppColors.white,
                      scrolledUnderElevation: 0,
                      floating: true,
                      snap: true,
                      elevation: 0,
                      titleSpacing: 18,
                      title: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.menu,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'facebook',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1.2,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Row(
                            children: [
                              GestureDetector(
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.black,
                                ),
                                onTap: () {},
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                child: const Icon(
                                  Icons.search,
                                  color: AppColors.black,
                                ),
                                onTap: () {},
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                child: const Icon(
                                  Icons.message_outlined,
                                  color: AppColors.black,
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const CreatePostSection(),
                          const SizedBox(height: 8),
                          StoriesSection(stories: _controller.stories),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: PostItem(
                            post: _controller.posts[index],
                            onLikeToggle: () => _controller.toggleLike(index),
                          ),
                        );
                      }, childCount: _controller.posts.length),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
