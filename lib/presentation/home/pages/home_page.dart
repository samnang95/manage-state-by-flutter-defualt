import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/home/controllers/home_controller.dart';
import 'package:manage_state/presentation/home/intents/home_intent.dart';
import 'package:manage_state/presentation/home/states/home_state.dart';
import 'package:manage_state/presentation/home/widgets/create_post_section.dart';
import 'package:manage_state/presentation/home/widgets/stories_section.dart';
import 'package:manage_state/presentation/home/widgets/post_item.dart';
import 'package:manage_state/presentation/camera/pages/native_camera_page.dart';
import 'package:manage_state/core/services/native_file_service.dart';

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
          child: ValueListenableBuilder<HomeState>(
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
                  _controller.onIntent(const RefreshHomeDataIntent());
                },
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
                          const Flexible(
                            child: Text(
                              'facebook',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 24, // reduced font size slightly
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.black,
                                ),
                                onTap: () {},
                              ),
                              const SizedBox(width: 12),
                              
                              // Camera feature 
                              GestureDetector(
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.black,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => NativeCameraPage()),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              
                              // Upload document feature
                              GestureDetector(
                                child: const Icon(
                                  Icons.description_outlined,
                                  color: AppColors.black,
                                ),
                                onTap: () async {
                                  final service = NativeFileService();
                                  final path = await service.pickFile();
                                  if (path != null && context.mounted) {
                                    // 1. Save File Permanently
                                    final fileName = path.split('/').last;
                                    final savedPath = await service.saveFileToDocuments(path, fileName);
                                    
                                    if (savedPath != null && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('File saved to:\n$savedPath')),
                                      );
                                    }
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                child: const Icon(
                                  Icons.search,
                                  color: AppColors.black,
                                ),
                                onTap: () {},
                              ),
                              const SizedBox(width: 12),
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
                          StoriesSection(stories: state.stories),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: PostItem(
                            post: state.posts[index],
                            onLikeToggle: () {
                              _controller.onIntent(TogglePostLikeIntent(index));
                            },
                          ),
                        );
                      }, childCount: state.posts.length),
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
