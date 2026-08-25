import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class CommentsHeader extends StatelessWidget {
  const CommentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatsRow(),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.grey300),
        _buildFilterRow(),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.thumb_up,
                  color: AppColors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '1.2K',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.black54,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.tertiary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '15 comments',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const Text(
            '31 shares',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Most relevant',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.black54,
            size: 20,
          ),
        ],
      ),
    );
  }
}
