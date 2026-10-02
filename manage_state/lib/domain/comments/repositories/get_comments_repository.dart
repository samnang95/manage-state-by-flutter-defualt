import 'package:manage_state/domain/comments/entities/comment.dart';

abstract class GetCommentsRepository {
  Future<List<Comment>> getComments();
}
