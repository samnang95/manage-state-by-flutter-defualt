import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';

class CommentInputBar extends StatefulWidget {
  final ValueChanged<String>? onSend;

  const CommentInputBar({super.key, this.onSend});

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend?.call(text);
    _controller.clear();
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.neutral,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSubmit(),
                decoration: const InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(color: AppColors.black54, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          if (_hasText) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: _handleSubmit,
              icon: const Icon(Icons.send_rounded, color: AppColors.primary),
              splashRadius: 20,
            ),
          ],
        ],
      ),
    );
  }
}
