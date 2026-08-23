import 'package:manage_state/domain/marketplace/entities/marketplace_item.dart';

class MarketplaceItemModel extends MarketplaceItem {
  const MarketplaceItemModel({
    required super.id,
    required super.imageUrl,
    required super.title,
    required super.price,
    super.isNearby = false,
  });

  factory MarketplaceItemModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceItemModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      price: json['price'],
      isNearby: json['isNearby'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'isNearby': isNearby,
    };
  }
}
