import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/notification/data/repositories/notification_repository_impl.dart';
import 'package:nepalink/features/dashboard/notification/domain/entities/notification_entity.dart';
import 'package:nepalink/features/dashboard/notification/domain/repositories/notification_repository.dart';

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((
  ref,
) {
  return GetNotificationsUsecase(
    repository: ref.read(notificationRepositoryProvider),
  );
});

class GetNotificationsUsecase
    implements UsecaseWithoutParms<List<NotificationEntity>> {
  final INotificationRepository _repo;

  GetNotificationsUsecase({required INotificationRepository repository})
    : _repo = repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() {
    return _repo.getNotifications();
  }
}

// lib/features/dashboard/notification/domain/usecases/mark_as_read_usecase.dart

final markAsReadUsecaseProvider = Provider<MarkAsReadUsecase>((ref) {
  return MarkAsReadUsecase(
    repository: ref.read(notificationRepositoryProvider),
  );
});

class MarkAsReadUsecase implements UsecaseWithParms<void, String> {
  final INotificationRepository _repo;

  MarkAsReadUsecase({required INotificationRepository repository})
    : _repo = repository;

  @override
  Future<Either<Failure, void>> call(String notificationId) {
    return _repo.markAsRead(notificationId);
  }
}

// lib/features/dashboard/notification/domain/usecases/mark_all_as_read_usecase.dart

final markAllAsReadUsecaseProvider = Provider<MarkAllAsReadUsecase>((ref) {
  return MarkAllAsReadUsecase(
    repository: ref.read(notificationRepositoryProvider),
  );
});

class MarkAllAsReadUsecase implements UsecaseWithoutParms<void> {
  final INotificationRepository _repo;

  MarkAllAsReadUsecase({required INotificationRepository repository})
    : _repo = repository;

  @override
  Future<Either<Failure, void>> call() {
    return _repo.markAllAsRead();
  }
}
