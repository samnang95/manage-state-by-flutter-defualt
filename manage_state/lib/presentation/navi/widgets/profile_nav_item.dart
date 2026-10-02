import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class ProfileNavItem extends StatelessWidget {
  final bool isSelected;
  final String avatarUrl;
  final VoidCallback onTap;
  final bool isDark;

  const ProfileNavItem({
    super.key,
    required this.isSelected,
    required this.avatarUrl,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active indicator line
          Container(
            width: 56,
            height: 3,
            decoration: BoxDecoration(
              color: isSelected && !isDark ? AppColors.primary : AppColors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected 
                    ? (isDark ? AppColors.white : AppColors.primary) 
                    : AppColors.transparent,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
        ],
      ),
    );
  }
}
