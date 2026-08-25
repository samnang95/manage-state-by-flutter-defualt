import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/presentation/comments/intents/comments_intent.dart';
import 'package:manage_state/presentation/comments/states/comments_state.dart';
import 'package:manage_state/domain/comments/usecases/get_comments_usecase.dart';

class CommentsController extends MviController<CommentsIntent, CommentsState> {
  final GetCommentsUseCase getCommentsUseCase;
  
  CommentsController({required this.getCommentsUseCase}) : super(const CommentsState());

  @override
  void onIntent(CommentsIntent intent) {
    switch (intent) {
      case LoadCommentsIntent(:final postId):
        _handleLoadComments(postId);
      case AddCommentIntent(:final postId, :final content):
        _handleAddComment(postId, content);
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
    debugPrint("Add comment: $content, postId: $postId");
  }
}
