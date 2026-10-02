import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/presentation/comments/intents/comments_intent.dart';
import 'package:manage_state/presentation/comments/states/comments_state.dart';
import 'package:manage_state/domain/comments/usecases/get_comments_usecase.dart';
import 'package:manage_state/domain/comments/usecases/create_comment_usecase.dart';
import 'package:manage_state/domain/comments/usecases/update_comment_usecase.dart';
import 'package:manage_state/domain/comments/usecases/delete_comment_usecase.dart';

class CommentsController extends MviController<CommentsIntent, CommentsState> {
  final GetCommentsUseCase getCommentsUseCase;
  final CreateCommentUseCase createCommentUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

  CommentsController({
    required this.getCommentsUseCase,
    required this.createCommentUseCase,
    required this.updateCommentUseCase,
    required this.deleteCommentUseCase,
  }) : super(const CommentsState());

  @override
  void onIntent(CommentsIntent intent) {
    switch (intent) {
      case LoadCommentsIntent(:final postId):
        _handleLoadComments(postId);
      case AddCommentIntent(:final postId, :final content):
        _handleAddComment(postId, content);
      case UpdateCommentIntent(:final id, :final content):
        _handleUpdateComment(id, content);
      case DeleteCommentIntent(:final id):
        _handleDeleteComment(id);
    }
  }

  Future<void> _handleLoadComments(int postId) async {
    emit(value.copyWith(isLoading: true, errorMessage: null));

    try {
      final comments = await getCommentsUseCase();

      emit(value.copyWith(
        isLoading: false,
        comments: comments,
      ));
    } catch (e) {
      debugPrint('Error loading comments: $e');
      emit(value.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _handleAddComment(int postId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    try {
      final newComment = await createCommentUseCase(content: trimmed, postId: postId);
      emit(value.copyWith(
        comments: [newComment, ...value.comments],
      ));
    } catch (e) {
      debugPrint('Error creating comment: $e');
    }
  }

  Future<void> _handleUpdateComment(int id, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    try {
      final updatedComment = await updateCommentUseCase(id: id, content: trimmed);
      final updatedList = value.comments.map((c) {
        return c.id == id ? updatedComment : c;
      }).toList();
      emit(value.copyWith(comments: updatedList));
    } catch (e) {
      debugPrint('Error updating comment: $e');
    }
  }

  Future<void> _handleDeleteComment(int id) async {
    try {
      await deleteCommentUseCase(id);
      final updatedList = value.comments.where((c) => c.id != id).toList();
      emit(value.copyWith(comments: updatedList));
    } catch (e) {
      debugPrint('Error deleting comment: $e');
    }
  }
}
