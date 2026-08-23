import 'package:manage_state/domain/reels/entities/reel_item.dart';

abstract class ReelsRepository {
  Future<List<ReelItem>> getReels();
}
