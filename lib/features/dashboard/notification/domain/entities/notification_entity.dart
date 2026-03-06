import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String recipientId;
  final String senderId;
  final String senderName;
  final String type; // "booking" | "chat"
  final String title;
  final String message;
  final bool isRead;
  final String? referenceId;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.recipientId,
    required this.senderId,
    required this.senderName,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    this.referenceId,
    required this.createdAt,
  });

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      recipientId: recipientId,
      senderId: senderId,
      senderName: senderName,
      type: type,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      referenceId: referenceId,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, isRead];
}
