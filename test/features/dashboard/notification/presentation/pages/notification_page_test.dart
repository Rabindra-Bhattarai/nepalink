import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/dashboard/notification/presentation/pages/notification_page.dart';
import 'package:nepalink/features/dashboard/notification/presentation/view_model/notification_view_model.dart';
import 'package:nepalink/features/dashboard/notification/presentation/state/notification_state.dart';
import 'package:nepalink/features/dashboard/notification/domain/entities/notification_entity.dart';

// Directly extends StateNotifier — no usecases, no repository, no crashes
class _StubNotificationViewModel extends StateNotifier<NotificationState>
    implements NotificationViewModel {
  _StubNotificationViewModel(NotificationState initial) : super(initial);

  @override
  Future<void> loadNotifications() async {}

  @override
  Future<void> markAsRead(String notificationId) async {
    final updated = state.notifications
        .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
        .toList();
    state = state.copyWith(
      notifications: updated,
      unreadCount: updated.where((n) => !n.isRead).length,
    );
  }

  @override
  Future<void> markAllAsRead() async {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    state = state.copyWith(notifications: updated, unreadCount: 0);
  }
}

Widget buildNotificationPage(NotificationState preloadedState) {
  return ProviderScope(
    overrides: [
      notificationViewModelProvider.overrideWith(
        (ref) => _StubNotificationViewModel(preloadedState),
      ),
    ],
    child: const MaterialApp(home: NotificationPage()),
  );
}

final tNotifications = [
  NotificationEntity(
    id: 'notif-001',
    recipientId: 'nurse-001',
    senderId: 'member-001',
    senderName: 'Ram Bahadur',
    type: 'booking',
    title: 'New Booking Request',
    message: 'You have a new booking request',
    isRead: false,
    createdAt: DateTime(2025, 3, 10),
  ),
  NotificationEntity(
    id: 'notif-002',
    recipientId: 'nurse-001',
    senderId: 'member-002',
    senderName: 'Sita Devi',
    type: 'chat',
    title: 'New Message',
    message: 'You have a new message from Sita',
    isRead: true,
    createdAt: DateTime(2025, 3, 11),
  ),
];

void main() {
  group('NotificationPage widget tests', () {
    testWidgets('shows Notifications app bar title', (tester) async {
      await tester.pumpWidget(
        buildNotificationPage(
          NotificationState(notifications: tNotifications, unreadCount: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('shows No Notifications when list is empty', (tester) async {
      await tester.pumpWidget(buildNotificationPage(const NotificationState()));
      await tester.pumpAndSettle();
      expect(find.text('No Notifications'), findsOneWidget);
    });

    testWidgets('shows notification title in list', (tester) async {
      await tester.pumpWidget(
        buildNotificationPage(
          NotificationState(notifications: tNotifications, unreadCount: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('New Booking Request'), findsOneWidget);
    });

    testWidgets('shows notification message in list', (tester) async {
      await tester.pumpWidget(
        buildNotificationPage(
          NotificationState(notifications: tNotifications, unreadCount: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('You have a new booking request'), findsOneWidget);
    });

    testWidgets('shows Mark all read button when unread notifications exist', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildNotificationPage(
          NotificationState(notifications: tNotifications, unreadCount: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Mark all read'), findsOneWidget);
    });

    testWidgets('does not show Mark all read when all are read', (
      tester,
    ) async {
      final allRead = tNotifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      await tester.pumpWidget(
        buildNotificationPage(
          NotificationState(notifications: allRead, unreadCount: 0),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Mark all read'), findsNothing);
    });

    testWidgets('shows error message when loading fails', (tester) async {
      await tester.pumpWidget(
        buildNotificationPage(
          const NotificationState(errorMessage: 'Failed to load notifications'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Failed to load notifications'), findsOneWidget);
    });

    testWidgets('shows Retry button on error', (tester) async {
      await tester.pumpWidget(
        buildNotificationPage(
          const NotificationState(errorMessage: 'Failed to load notifications'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows two notification cards when two notifications loaded', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildNotificationPage(
          NotificationState(notifications: tNotifications, unreadCount: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('New Booking Request'), findsOneWidget);
      expect(find.text('New Message'), findsOneWidget);
    });

    testWidgets('shows You are all caught up text when empty', (tester) async {
      await tester.pumpWidget(buildNotificationPage(const NotificationState()));
      await tester.pumpAndSettle();
      expect(find.text("You're all caught up!"), findsOneWidget);
    });
  });
}
