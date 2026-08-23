import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/domain/profile/entities/user_profile.dart';

class PersonalDetailsSection extends StatelessWidget {
  final UserProfile profile;

  const PersonalDetailsSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Personal details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.edit_outlined,
                  size: 22,
                  color: AppColors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Detail items
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: profile.location,
          ),
          _DetailRow(
            icon: Icons.home_outlined,
            label: profile.hometown,
          ),
          _DetailRow(
            icon: Icons.cake_outlined,
            label: profile.birthday,
          ),
          _DetailRow(
            icon: Icons.favorite_border,
            label: profile.relationshipStatus,
          ),
          _DetailRow(
            icon: Icons.visibility_outlined,
            label: profile.gender,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 26, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: AppColors.black.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
