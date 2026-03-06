// lib/features/dashboard/notification/data/repositories/notification_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/notification/data/datasources/notification_remote_datasource.dart';
import 'package:nepalink/features/dashboard/notification/domain/entities/notification_entity.dart';
import 'package:nepalink/features/dashboard/notification/domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remote: ref.read(notificationRemoteDataSourceProvider),
  );
});

class NotificationRepositoryImpl implements INotificationRepository {
  final NotificationRemoteDataSource _remote;

  NotificationRepositoryImpl({required NotificationRemoteDataSource remote})
    : _remote = remote;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final result = await _remote.getNotifications();
      return Right(result.notifications.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _remote.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remote.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
