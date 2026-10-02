import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/reels/controllers/reels_controller.dart';
import 'package:manage_state/presentation/reels/intents/reels_intent.dart';
import 'package:manage_state/presentation/reels/states/reels_state.dart';
import 'package:manage_state/presentation/reels/widgets/reel_video_widget.dart';

class ReelsPage extends StatelessWidget {
  ReelsPage({super.key});

  final ReelsController _controller = DependencyInjector.instance.getReelsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: ValueListenableBuilder<ReelsState>(
        valueListenable: _controller,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Stack(
            children: [
              // Full screen vertical pager
              RefreshIndicator(
                onRefresh: () async {
                  _controller.onIntent(const RefreshReelsIntent());
                },
                color: AppColors.primary,
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.reels.length,
                  onPageChanged: (index) {
                    _controller.onIntent(ChangeReelPageIntent(index));
                  },
                  itemBuilder: (context, index) {
                    return ReelVideoWidget(reel: state.reels[index]);
                  },
                ),
              ),
              // Custom top app bar overlay
              SafeArea(
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
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Reels',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.search,
                              color: AppColors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.more_horiz,
                              color: AppColors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
