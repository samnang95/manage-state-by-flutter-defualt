import 'package:manage_state/domain/comments/entities/comment.dart';

abstract class CommentsRepository {
  Future<List<Comment>> getComments();
}
