import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/domain/friends/entities/friend_request.dart';

class FriendRequestCard extends StatelessWidget {
  const FriendRequestCard({
    super.key,
    required this.request,
    required this.onConfirm,
    required this.onDelete,
  });

  final FriendRequest request;
  final VoidCallback onConfirm;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with optional online indicator
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Image.network(
                  request.avatar,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              if (request.isOnline)
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Info + buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  request.name,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Mutual friends row
                Row(
                  children: [
                    // Stacked small avatars
                    SizedBox(
                      width: 36,
                      height: 20,
                      child: Stack(
                        children: [
                          for (
                            int i = 0;
                            i < request.mutualAvatars.length &&
                                i < 2;
                            i++
                          )
                            Positioned(
                              left: i * 14.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundImage: NetworkImage(
                                    request.mutualAvatars[i],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '${request.mutualFriends} mutual friends',
                      style: const TextStyle(
                        color: AppColors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '·',
                      style: TextStyle(color: AppColors.black54, fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      request.timeAgo,
                      style: const TextStyle(
                        color: AppColors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onConfirm,
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.grey300,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child:  Text(
                            'Delete',
                            style: TextStyle(
                              color: AppColors.black.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
