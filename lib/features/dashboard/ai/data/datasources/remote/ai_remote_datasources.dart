import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/ai/data/models/ai_model.dart';

final aiRemoteDataSourceProvider = Provider<AiRemoteDataSource>((ref) {
  return AiRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class AiRemoteDataSource {
  final ApiClient _apiClient;
  AiRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<AiModel>> getAiSummaries() async {
    final response = await _apiClient.get(ApiEndpoints.activitiesAssigned);
    final List<dynamic> data = response.data['data'];
    return data.map((json) => AiModel.fromJson(json)).toList();
  }
}
