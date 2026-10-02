import 'package:manage_state/data/reels/datasources/reels_remote_datasource.dart';
import 'package:manage_state/domain/reels/entities/reel_item.dart';
import 'package:manage_state/domain/reels/repositories/reels_repository.dart';

class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource remoteDataSource;

  ReelsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReelItem>> getReels() async {
    try {
      return await remoteDataSource.getReels();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
