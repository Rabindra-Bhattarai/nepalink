import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/notification/domain/entities/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Future<Either<Failure, void>> markAllAsRead();
}
