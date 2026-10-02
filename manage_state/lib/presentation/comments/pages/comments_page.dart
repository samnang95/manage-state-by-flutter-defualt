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
                        onEdit: () => _showEditDialog(context, comment.id, comment.body),
                        onDelete: () => _showDeleteDialog(context, comment.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          CommentInputBar(
            onSend: (content) {
              controller.onIntent(AddCommentIntent(postId: 1, content: content));
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int commentId, String currentBody) {
    final editController = TextEditingController(text: currentBody);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Comment'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Edit your comment...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newText = editController.text.trim();
              if (newText.isNotEmpty && newText != currentBody) {
                controller.onIntent(
                  UpdateCommentIntent(id: commentId, content: newText),
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.onIntent(DeleteCommentIntent(commentId));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
