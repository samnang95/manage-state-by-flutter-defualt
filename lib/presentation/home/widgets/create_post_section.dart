import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class CreatePostSection extends StatelessWidget {
  const CreatePostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "What's on your mind?",
                    style: TextStyle(color: AppColors.black, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.image,
                  size: 24,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
