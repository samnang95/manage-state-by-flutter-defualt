import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

import 'package:manage_state/domain/comments/entities/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool hasSeeOriginal;
  final int? repliesCount;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentItem({
    super.key,
    required this.comment,
    this.hasSeeOriginal = false,
    this.repliesCount,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.neutral,
          child: Icon(Icons.person, size: 20, color: AppColors.grey300),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.neutral,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              comment.user.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              comment.timeAgo ?? 'Just now',
                              style: const TextStyle(
                                color: AppColors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if (onEdit != null || onDelete != null)
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              icon: const Icon(Icons.more_horiz, color: AppColors.black54),
                              onSelected: (value) {
                                if (value == 'edit') onEdit?.call();
                                if (value == 'delete') onDelete?.call();
                              },
                              itemBuilder: (context) => [
                                if (onEdit != null)
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                if (onDelete != null)
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.body,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              if (hasSeeOriginal)
                const Padding(
                  padding: EdgeInsets.only(top: 4, left: 8),
                  child: Text(
                    'See original',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    const Text(
                      'Reply',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    if (comment.likes > 0)
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
                              size: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('${comment.likes}', style: const TextStyle(color: AppColors.black54)),
                        ],
                      ),
                    const SizedBox(width: 16),
                    const Icon(Icons.thumb_up_alt_outlined, size: 16, color: AppColors.black54),
                    const SizedBox(width: 16),
                    const Icon(Icons.thumb_down_alt_outlined, size: 16, color: AppColors.black54),
                  ],
                ),
              ),
              if (repliesCount != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.black54),
                      const SizedBox(width: 4),
                      Text(
                        'View $repliesCount reply',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
