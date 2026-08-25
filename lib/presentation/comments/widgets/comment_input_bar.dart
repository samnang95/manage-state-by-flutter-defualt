import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class CommentInputBar extends StatelessWidget {
  const CommentInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey300)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.neutral,
            child: Icon(Icons.person, color: AppColors.grey300),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Write a comment...',
                style: TextStyle(color: AppColors.black54, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
