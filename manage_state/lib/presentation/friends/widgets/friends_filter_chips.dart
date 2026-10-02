import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class FriendsFilterChips extends StatelessWidget {
  const FriendsFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilterIndex,
    required this.onFilterTap,
  });

  final List<String> filters;
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedFilterIndex == index;
          final isOnlineChip = index == 0;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.neutral,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOnlineChip) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.white : AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      filters[index],
                      style: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
