import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class MarketplaceTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const MarketplaceTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  static const _tabs = ['Sell', 'Explore', 'Local', 'More'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Tab items
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 18),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = index == selectedIndex;
                final isMore = index == 3;
                return GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 14 : 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _tabs[index],
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isMore) ...[
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.black,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        // Divider + Location icon
        Container(
          margin: const EdgeInsets.only(left: 8, right: 16),
          padding: const EdgeInsets.only(left: 12),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.grey300, width: 1),
            ),
          ),
          child: const Icon(
            Icons.location_on,
            color: AppColors.black,
            size: 26,
          ),
        ),
      ],
    );
  }
}
