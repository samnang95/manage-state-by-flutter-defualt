import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class NavItem extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final IconData activeIcon;
  final VoidCallback onTap;
  final bool isDark;

  const NavItem({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.activeIcon,
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
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected 
                ? (isDark ? AppColors.white : AppColors.primary) 
                : (isDark ? AppColors.white.withValues(alpha: 0.5) : AppColors.black),
            size: 28,
          ),
        ],
      ),
    );
  }
}
