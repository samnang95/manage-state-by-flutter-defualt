import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/comments/controllers/comments_controller.dart';
import 'package:manage_state/presentation/comments/intents/comments_intent.dart';
import 'package:manage_state/presentation/comments/states/comments_state.dart';

import 'package:manage_state/presentation/comments/widgets/comments_header.dart';
import 'package:manage_state/presentation/comments/widgets/author_comment_item.dart';
import 'package:manage_state/presentation/comments/widgets/comment_item.dart';
import 'package:manage_state/presentation/comments/widgets/comment_input_bar.dart';

class CommentsPage extends StatelessWidget {
  final CommentsController controller;

  const CommentsPage({super.key, required this.controller});

  static void show(BuildContext context) {
    final controller = DependencyInjector.instance.getCommentsController();
    // Pass a dummy postId since the Post entity doesn't have an ID yet
    controller.onIntent(const LoadCommentsIntent(242));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CommentsPage(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const CommentsHeader(),
          Expanded(
            child: ValueListenableBuilder<CommentsState>(
              valueListenable: controller,
              builder: (context, state, child) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Text(
                      state.errorMessage!, 
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  // +1 to account for the author's original comment at the top
                  itemCount: state.comments.length + 1, 
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: AuthorCommentItem(),
                      );
                    }
                    
                    final comment = state.comments[index - 1];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CommentItem(
                        comment: comment,
                        hasSeeOriginal: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const CommentInputBar(),
        ],
      ),
    );
  }
}
