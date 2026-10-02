import 'package:manage_state/domain/comments/entities/comment.dart';

class CommentsState {
  final bool isLoading;
  final List<Comment> comments;
  final String? errorMessage;

  const CommentsState({
    this.isLoading = true,
    this.comments = const [],
    this.errorMessage,
  });

  CommentsState copyWith({
    bool? isLoading,
    List<Comment>? comments,
    String? errorMessage,
  }) {
    return CommentsState(
      isLoading: isLoading ?? this.isLoading,
      comments: comments ?? this.comments,
      errorMessage: errorMessage,
    );
  }
}
