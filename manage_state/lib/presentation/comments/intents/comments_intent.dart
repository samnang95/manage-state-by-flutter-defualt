sealed class CommentsIntent {
  const CommentsIntent();
}

class LoadCommentsIntent extends CommentsIntent {
  final int postId;
  const LoadCommentsIntent(this.postId);
}

class AddCommentIntent extends CommentsIntent {
  final int postId;
  final String content;
  const AddCommentIntent({required this.postId, required this.content});
}

class UpdateCommentIntent extends CommentsIntent {
  final int id;
  final String content;
  const UpdateCommentIntent({required this.id, required this.content});
}

class DeleteCommentIntent extends CommentsIntent {
  final int id;
  const DeleteCommentIntent(this.id);
}
