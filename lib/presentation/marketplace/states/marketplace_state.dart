import 'package:manage_state/domain/marketplace/entities/marketplace_item.dart';

class MarketplaceState {
  final bool isLoading;
  final int selectedTabIndex;
  final List<MarketplaceItem> items;
  final String? errorMessage;

  const MarketplaceState({
    this.isLoading = true,
    this.selectedTabIndex = 1,
    this.items = const [],
    this.errorMessage,
  });

  MarketplaceState copyWith({
    bool? isLoading,
    int? selectedTabIndex,
    List<MarketplaceItem>? items,
    String? errorMessage,
  }) {
    return MarketplaceState(
      isLoading: isLoading ?? this.isLoading,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}
