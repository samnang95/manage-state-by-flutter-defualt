import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location + relationship status
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.black),
              const SizedBox(width: 4),
              const Text(
                'Phnom Penh',
                style: TextStyle(color: AppColors.black, fontSize: 14),
              ),
              const SizedBox(width: 8),
              const Text(
                '·',
                style: TextStyle(color: AppColors.black, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.favorite,
                size: 14,
                color: AppColors.black,
              ),
              const SizedBox(width: 4),
              const Text(
                'Single',
                style: TextStyle(color: AppColors.black, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mutual friends row
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 28,
                child: Stack(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Positioned(
                        left: i * 18.0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/100?img=${i + 20}',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Friends with things in common',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
