import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/notification/domain/entities/notification_entity.dart';
import 'package:nepalink/features/dashboard/notification/domain/usecases/notification_usecases.dart';
import 'package:nepalink/features/dashboard/notification/presentation/view_model/notification_view_model.dart';

@GenerateMocks([
  GetNotificationsUsecase,
  MarkAsReadUsecase,
  MarkAllAsReadUsecase,
])
import 'notification_view_model_test.mocks.dart';

void main() {
  late NotificationViewModel notificationViewModel;
  late MockGetNotificationsUsecase mockGetNotifications;
  late MockMarkAsReadUsecase mockMarkAsRead;
  late MockMarkAllAsReadUsecase mockMarkAllAsRead;

  final tNotifications = [
    NotificationEntity(
      id: 'notif-001',
      recipientId: 'nurse-001',
      senderId: 'member-001',
      senderName: 'Ram Bahadur',
      type: 'booking',
      title: 'New Booking',
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
      message: 'You have a new message',
      isRead: true,
      createdAt: DateTime(2025, 3, 11),
    ),
  ];

  setUp(() {
    mockGetNotifications = MockGetNotificationsUsecase();
    mockMarkAsRead = MockMarkAsReadUsecase();
    mockMarkAllAsRead = MockMarkAllAsReadUsecase();

    notificationViewModel = NotificationViewModel(
      getNotifications: mockGetNotifications,
      markAsRead: mockMarkAsRead,
      markAllAsRead: mockMarkAllAsRead,
    );
  });

  tearDown(() {
    notificationViewModel.dispose();
  });

  group('NotificationViewModel', () {
    test('initial state has empty notifications and zero unread count', () {
      expect(notificationViewModel.state.notifications, isEmpty);
      expect(notificationViewModel.state.unreadCount, 0);
      expect(notificationViewModel.state.isLoading, false);
    });

    test(
      'loads notifications and sets correct unread count on success',
      () async {
        when(
          mockGetNotifications.call(),
        ).thenAnswer((_) async => Right(tNotifications));

        await notificationViewModel.loadNotifications();

        expect(notificationViewModel.state.notifications.length, 2);
        expect(notificationViewModel.state.unreadCount, 1);
        expect(notificationViewModel.state.isLoading, false);
        expect(notificationViewModel.state.errorMessage, isNull);
      },
    );

    test('sets errorMessage when loadNotifications fails', () async {
      when(mockGetNotifications.call()).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Failed to load notifications')),
      );

      await notificationViewModel.loadNotifications();

      expect(
        notificationViewModel.state.errorMessage,
        'Failed to load notifications',
      );
      expect(notificationViewModel.state.isLoading, false);
      expect(notificationViewModel.state.notifications, isEmpty);
    });

    test(
      'markAsRead updates notification and decreases unread count',
      () async {
        when(
          mockGetNotifications.call(),
        ).thenAnswer((_) async => Right(tNotifications));
        await notificationViewModel.loadNotifications();

        when(
          mockMarkAsRead.call(any),
        ).thenAnswer((_) async => const Right(null));

        await notificationViewModel.markAsRead('notif-001');

        expect(
          notificationViewModel.state.notifications
              .firstWhere((n) => n.id == 'notif-001')
              .isRead,
          true,
        );
        expect(notificationViewModel.state.unreadCount, 0);
      },
    );

    test(
      'markAllAsRead sets all notifications as read and unread count to 0',
      () async {
        when(
          mockGetNotifications.call(),
        ).thenAnswer((_) async => Right(tNotifications));
        await notificationViewModel.loadNotifications();

        when(
          mockMarkAllAsRead.call(),
        ).thenAnswer((_) async => const Right(null));

        await notificationViewModel.markAllAsRead();

        expect(
          notificationViewModel.state.notifications.every((n) => n.isRead),
          true,
        );
        expect(notificationViewModel.state.unreadCount, 0);
      },
    );
  });
}
