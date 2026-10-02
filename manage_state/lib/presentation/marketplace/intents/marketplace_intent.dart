sealed class MarketplaceIntent {
  const MarketplaceIntent();
}

class LoadMarketplaceIntent extends MarketplaceIntent {
  const LoadMarketplaceIntent();
}

class RefreshMarketplaceIntent extends MarketplaceIntent {
  const RefreshMarketplaceIntent();
}

class ChangeMarketplaceTabIntent extends MarketplaceIntent {
  final int index;
  const ChangeMarketplaceTabIntent(this.index);
}
