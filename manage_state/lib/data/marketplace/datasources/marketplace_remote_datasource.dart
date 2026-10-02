import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';
import 'package:manage_state/data/marketplace/models/marketplace_item_model.dart';

abstract class MarketplaceRemoteDataSource {
  Future<List<MarketplaceItemModel>> getItems();
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  final ApiClient apiClient;

  MarketplaceRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MarketplaceItemModel>> getItems() async {
    final response = await apiClient.get(ApiEndpoints.marketplaceItems);

    if (response is List) {
      return response
          .map((json) =>
              MarketplaceItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
