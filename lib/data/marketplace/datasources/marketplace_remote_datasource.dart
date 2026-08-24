import 'package:manage_state/core/network/api_client.dart';

import 'package:manage_state/data/marketplace/models/marketplace_item_model.dart';

abstract class MarketplaceRemoteDataSource {
  Future<List<MarketplaceItemModel>> getItems();
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  final ApiClient apiClient;

  MarketplaceRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MarketplaceItemModel>> getItems() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final data = [
      {
        'id': '1',
        'imageUrl': 'https://picsum.photos/seed/camera1/400/400',
        'title': 'Sony A7iii Body',
        'price': '\$567',
        'isNearby': false,
      },
      {
        'id': '2',
        'imageUrl': 'https://picsum.photos/seed/camera2/400/400',
        'title': 'Canon m10',
        'price': 'Free',
        'isNearby': true,
      },
      {
        'id': '3',
        'imageUrl': 'https://picsum.photos/seed/camera3/400/400',
        'title': 'Canon EOS 600D with Lens',
        'price': '\$2',
        'isNearby': true,
      },
      {
        'id': '4',
        'imageUrl': 'https://picsum.photos/seed/ipad1/400/400',
        'title': 'iPad Pro M1 2021 256GB',
        'price': '\$395',
        'isNearby': false,
      },
      {
        'id': '5',
        'imageUrl': 'https://picsum.photos/seed/camera5/400/400',
        'title': 'Sony Alpha Mirrorless',
        'price': '\$320',
        'isNearby': true,
      },
      {
        'id': '6',
        'imageUrl': 'https://picsum.photos/seed/camera6/400/400',
        'title': 'Sony A7R IV Body',
        'price': '\$1,200',
        'isNearby': true,
      },
      {
        'id': '7',
        'imageUrl': 'https://picsum.photos/seed/laptop1/400/400',
        'title': 'MacBook Pro 14" M2',
        'price': '\$899',
        'isNearby': false,
      },
      {
        'id': '8',
        'imageUrl': 'https://picsum.photos/seed/phone1/400/400',
        'title': 'iPhone 15 Pro Max 256GB',
        'price': '\$750',
        'isNearby': true,
      },
    ];

    return data.map((json) => MarketplaceItemModel.fromJson(json)).toList();
  }
}
