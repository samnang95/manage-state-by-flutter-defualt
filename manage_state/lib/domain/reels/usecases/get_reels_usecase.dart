import 'package:manage_state/domain/reels/entities/reel_item.dart';
import 'package:manage_state/domain/reels/repositories/reels_repository.dart';

class GetReelsUseCase {
  final ReelsRepository repository;

  GetReelsUseCase(this.repository);

  Future<List<ReelItem>> call() {
    return repository.getReels();
  }
}
