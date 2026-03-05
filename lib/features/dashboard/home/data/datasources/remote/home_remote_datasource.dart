import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/home/data/datasources/home_datasource.dart';
import 'package:nepalink/features/dashboard/home/data/models/activity_api_model.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';

final homeRemoteDataSourceProvider = Provider<IHomeRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return HomeRemoteDataSource(apiClient.dio);
});

class HomeRemoteDataSource implements IHomeRemoteDataSource {
  final Dio _dio;
  HomeRemoteDataSource(this._dio);

  @override
  Future<List<ActivityEntity>> getAssignedActivities() async {
    // GET /activities/assigned  — nurse only, JWT auto-attached by AuthInterceptor
    final response = await _dio.get(ApiEndpoints.activitiesAssigned);
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((json) => ActivityApiModel.fromJson(json).toEntity())
        .toList();
  }
}
