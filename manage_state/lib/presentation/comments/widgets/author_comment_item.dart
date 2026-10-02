import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class AuthorCommentItem extends StatelessWidget {
  const AuthorCommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.neutral,
          child: Icon(Icons.business, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Business Cambodia',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '2d',
                    style: TextStyle(
                      color: AppColors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.edit, size: 12, color: AppColors.primary),
                  const SizedBox(width: 4),
                  const Text(
                    'Author',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'https://business-cambodia.com/articles/four-bank-and-gold-price-end-of-2026',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.neutral,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                      child: const Center(child: Icon(Icons.image, color: AppColors.grey300)),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BUSINESS-CAMBODIA.COM',
                              style: TextStyle(fontSize: 10, color: AppColors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'មាសឡើងដល់ណា! ធនាគារធំៗ៤របស់ អាមេរិកថាត្រឹមចុងឆ្នាំ២០២៦ មាស...',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
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
                      const Text('2', style: TextStyle(color: AppColors.black54)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.thumb_up_alt_outlined, size: 16, color: AppColors.black54),
                  const SizedBox(width: 16),
                  const Icon(Icons.thumb_down_alt_outlined, size: 16, color: AppColors.black54),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
