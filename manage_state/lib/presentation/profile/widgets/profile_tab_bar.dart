import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class ProfileTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const ProfileTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  static const _tabs = ['All', 'Photos', 'Reels', 'Memories'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.black54,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w400 : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
      ),
    ),
    );
  }
}
