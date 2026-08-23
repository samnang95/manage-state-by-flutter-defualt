import 'package:manage_state/domain/marketplace/entities/marketplace_item.dart';

abstract class MarketplaceRepository {
  Future<List<MarketplaceItem>> getItems();
}
