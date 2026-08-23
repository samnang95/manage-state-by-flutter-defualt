import 'package:manage_state/domain/marketplace/entities/marketplace_item.dart';
import 'package:manage_state/domain/marketplace/repositories/marketplace_repository.dart';

class GetMarketplaceItemsUseCase {
  final MarketplaceRepository repository;

  GetMarketplaceItemsUseCase(this.repository);

  Future<List<MarketplaceItem>> call() {
    return repository.getItems();
  }
}
