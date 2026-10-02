import 'package:manage_state/data/marketplace/datasources/marketplace_remote_datasource.dart';
import 'package:manage_state/domain/marketplace/entities/marketplace_item.dart';
import 'package:manage_state/domain/marketplace/repositories/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final MarketplaceRemoteDataSource remoteDataSource;

  MarketplaceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MarketplaceItem>> getItems() async {
    try {
      final models = await remoteDataSource.getItems();
      return models;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
