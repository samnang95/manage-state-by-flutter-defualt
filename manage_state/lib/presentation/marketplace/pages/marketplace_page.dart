import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/marketplace/controllers/marketplace_controller.dart';
import 'package:manage_state/presentation/marketplace/intents/marketplace_intent.dart';
import 'package:manage_state/presentation/marketplace/states/marketplace_state.dart';
import 'package:manage_state/presentation/marketplace/widgets/marketplace_tab_bar.dart';
import 'package:manage_state/presentation/marketplace/widgets/marketplace_product_card.dart';

class MarketplacePage extends StatelessWidget {
  MarketplacePage({super.key});

  final MarketplaceController _controller = DependencyInjector.instance.getMarketplaceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ValueListenableBuilder<MarketplaceState>(
          valueListenable: _controller,
          builder: (context, state, _) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _controller.onIntent(const RefreshMarketplaceIntent());
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
                                'Marketplace',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.search,
                                  color: AppColors.black,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: AppColors.black,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tab bar
                  SliverToBoxAdapter(
                    child: MarketplaceTabBar(
                      selectedIndex: state.selectedTabIndex,
                      onTabChanged: (index) {
                        _controller.onIntent(ChangeMarketplaceTabIntent(index));
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  // Product grid
                  SliverPadding(
                    padding: EdgeInsets.zero,
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            childAspectRatio: 0.85,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return MarketplaceProductCard(
                          item: state.items[index],
                        );
                      }, childCount: state.items.length),
                    ),
                  ),
                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
