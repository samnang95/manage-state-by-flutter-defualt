import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/marketplace/usecases/get_marketplace_items_usecase.dart';
import 'package:manage_state/presentation/marketplace/intents/marketplace_intent.dart';
import 'package:manage_state/presentation/marketplace/states/marketplace_state.dart';

class MarketplaceController
    extends MviController<MarketplaceIntent, MarketplaceState> {
  final GetMarketplaceItemsUseCase getItemsUseCase;

  MarketplaceController({required this.getItemsUseCase})
    : super(const MarketplaceState()) {
    onIntent(const LoadMarketplaceIntent());
  }

  static const tabs = ['Sell', 'Explore', 'Local', 'More'];

  @override
  void onIntent(MarketplaceIntent intent) {
    switch (intent) {
      case LoadMarketplaceIntent():
        _handleLoadData();
      case RefreshMarketplaceIntent():
        _handleRefreshData();
      case ChangeMarketplaceTabIntent(:final index):
        _handleChangeTab(index);
    }
  }

  Future<void> _handleLoadData() async {
    emit(value.copyWith(isLoading: true, errorMessage: null));

    try {
      final items = await getItemsUseCase();
      emit(value.copyWith(isLoading: false, items: items));
    } catch (e) {
      debugPrint('Error loading marketplace items: $e');
      emit(value.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _handleRefreshData() async {
    try {
      final items = await getItemsUseCase();
      emit(value.copyWith(items: items));
    } catch (e) {
      debugPrint('Error refreshing marketplace items: $e');
    }
  }

  void _handleChangeTab(int index) {
    emit(value.copyWith(selectedTabIndex: index));
  }
}
