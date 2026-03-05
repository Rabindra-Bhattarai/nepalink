import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/dashboard/notification/domain/usecases/notification_usecases.dart';
import 'package:nepalink/features/dashboard/notification/presentation/state/notification_state.dart';

final notificationViewModelProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
      return NotificationViewModel(
        getNotifications: ref.read(getNotificationsUsecaseProvider),
        markAsRead: ref.read(markAsReadUsecaseProvider),
        markAllAsRead: ref.read(markAllAsReadUsecaseProvider),
      );
    });

class NotificationViewModel extends StateNotifier<NotificationState> {
  final GetNotificationsUsecase _getNotifications;
  final MarkAsReadUsecase _markAsRead;
  final MarkAllAsReadUsecase _markAllAsRead;

  NotificationViewModel({
    required GetNotificationsUsecase getNotifications,
    required MarkAsReadUsecase markAsRead,
    required MarkAllAsReadUsecase markAllAsRead,
  }) : _getNotifications = getNotifications,
       _markAsRead = markAsRead,
       _markAllAsRead = markAllAsRead,
       // ✅ No loadNotifications() here — screen calls it after token is ready
       super(const NotificationState());

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getNotifications.call();
    result.fold(
      (failure) {
        print("❌ Notification load failed: ${failure.message}");
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (notifications) {
        print("✅ Loaded ${notifications.length} notifications");
        state = state.copyWith(
          isLoading: false,
          notifications: notifications,
          unreadCount: notifications.where((n) => !n.isRead).length,
        );
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final updated = state.notifications
        .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
        .toList();

    state = state.copyWith(
      notifications: updated,
      unreadCount: updated.where((n) => !n.isRead).length,
    );

    await _markAsRead.call(notificationId);
  }

  Future<void> markAllAsRead() async {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();

    state = state.copyWith(notifications: updated, unreadCount: 0);

    await _markAllAsRead.call();
  }
}
