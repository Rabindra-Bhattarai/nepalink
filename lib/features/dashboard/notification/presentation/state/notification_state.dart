// lib/features/dashboard/notification/presentation/state/notification_state.dart

import 'package:equatable/equatable.dart';
import 'package:nepalink/features/dashboard/notification/domain/entities/notification_entity.dart';

class NotificationState extends Equatable {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    unreadCount,
    isLoading,
    errorMessage,
  ];
}
