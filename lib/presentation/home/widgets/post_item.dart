import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/domain/home/entities/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback onLikeToggle;

  const PostItem({
    super.key,
    required this.post,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(post.authorAvatar),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                      Row(
                        children: [
                          Text('${post.timeAgo} · ', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const Icon(Icons.public, color: Colors.grey, size: 12),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              post.content,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: 8),
          // Image
          Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          // Footer Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.thumb_up, color: Colors.white, size: 12),
                ),
                const SizedBox(width: 2),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 12),
                ),
                const SizedBox(width: 6),
                Text('${post.likes}', style: const TextStyle(color: Colors.black54)),
                const Spacer(),
                Text('${post.comments} comments   ${post.shares} shares', style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          // Footer Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterActionButton(
                icon: Icons.thumb_up_alt_outlined, 
                label: 'Like',
                isActive: post.isLiked,
                onPressed: onLikeToggle,
              ),
              _buildFooterActionButton(
                icon: Icons.comment_outlined, 
                label: 'Comment',
                isActive: false,
                onPressed: () {},
              ),
              _buildFooterActionButton(
                icon: Icons.share_outlined, 
                label: 'Share',
                isActive: false,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActionButton({
    required IconData icon, 
    required String label, 
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    final color = isActive ? AppColors.primary : Colors.grey[600];
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: color),
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
    );
  }
}
