import 'package:flutter/material.dart';
import 'package:manage_state/domain/marketplace/entities/marketplace_item.dart';
import 'package:manage_state/domain/marketplace/usecases/get_marketplace_items_usecase.dart';

class MarketplaceController extends ChangeNotifier {
  final GetMarketplaceItemsUseCase getItemsUseCase;

  MarketplaceController({required this.getItemsUseCase}) {
    _loadData();
  }

  int _selectedTabIndex = 1; // "Explore" selected by default

  int get selectedTabIndex => _selectedTabIndex;

  static const tabs = ['Sell', 'Explore', 'Local', 'More'];

  void changeTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  List<MarketplaceItem> items = [];
  bool isLoading = true;

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      items = await getItemsUseCase();
    } catch (e) {
      debugPrint('Error loading marketplace items: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    try {
      items = await getItemsUseCase();
    } catch (e) {
      debugPrint('Error refreshing marketplace items: $e');
    }
    notifyListeners();
  }
}
