import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/notification/data/models/notification_api_model.dart';

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      return NotificationRemoteDataSource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Returns notifications list + unreadCount from the server
  Future<({List<NotificationApiModel> notifications, int unreadCount})>
  getNotifications() async {
    final response = await _apiClient.get(ApiEndpoints.notifications);
    final List<dynamic> data = response.data['data'];
    final int unreadCount = response.data['unreadCount'] as int;
    return (
      notifications: data
          .map(
            (json) =>
                NotificationApiModel.fromJson(json as Map<String, dynamic>),
          )
          .toList(),
      unreadCount: unreadCount,
    );
  }

  /// Mark a single notification as read
  Future<void> markAsRead(String notificationId) async {
    await _apiClient.patch(ApiEndpoints.notificationMarkRead(notificationId));
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    await _apiClient.patch(ApiEndpoints.notificationsMarkAllRead);
  }
}
