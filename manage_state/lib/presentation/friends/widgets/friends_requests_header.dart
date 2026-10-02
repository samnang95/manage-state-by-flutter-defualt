import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class FriendsRequestsHeader extends StatelessWidget {
  const FriendsRequestsHeader({
    super.key,
    required this.requestCount,
  });

  final int requestCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const Text(
            'Friend Requests',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$requestCount',
            style: const TextStyle(
              color: AppColors.redAccent,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'See all',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
