import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/domain/reels/entities/reel_item.dart';

class ReelVideoWidget extends StatelessWidget {
  final ReelItem reel;

  const ReelVideoWidget({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Video/Thumbnail
        Image.network(
          reel.thumbnailUrl,
          fit: BoxFit.cover,
        ),
        // Dark gradient overlay for text readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.transparent,
                AppColors.black.withValues(alpha: 0.6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        // Right side action buttons
        Positioned(
          right: 16,
          bottom: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionItem(Icons.thumb_up_alt_outlined, reel.likesCount),
              const SizedBox(height: 20),
              _buildActionItem(Icons.chat_bubble_outline, reel.commentsCount),
              const SizedBox(height: 20),
              _buildActionItem(Icons.reply_outlined, reel.sharesCount),
              const SizedBox(height: 20),
              _buildActionItem(Icons.bookmark_border, reel.savesCount),
              const SizedBox(height: 20),
              _buildActionItem(Icons.more_horiz, ''),
            ],
          ),
        ),
        // Bottom left author info & description
        Positioned(
          left: 16,
          bottom: 24,
          right: 80, // Prevent overlapping with right side buttons
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(reel.authorAvatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      reel.authorName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.public,
                    color: AppColors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  if (!reel.isFollowing)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.white),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                reel.description,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 30),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
