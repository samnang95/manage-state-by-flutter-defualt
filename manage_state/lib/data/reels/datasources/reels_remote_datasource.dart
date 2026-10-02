import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/api_endpoints.dart';
import 'package:manage_state/data/reels/models/reel_item_model.dart';

abstract class ReelsRemoteDataSource {
  Future<List<ReelItemModel>> getReels();
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final ApiClient apiClient;

  ReelsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ReelItemModel>> getReels() async {
    final response = await apiClient.get(ApiEndpoints.reels);

    if (response is List) {
      return response
          .map((json) => ReelItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
