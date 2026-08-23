class MarketplaceItem {
  final String id;
  final String imageUrl;
  final String title;
  final String price;
  final bool isNearby;

  const MarketplaceItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.isNearby = false,
  });
}
