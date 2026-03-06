import 'package:nepalink/features/dashboard/notification/domain/entities/notification_entity.dart';

class NotificationApiModel {
  final String id;
  final String recipientId;
  final String senderId;
  final String senderName;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final String? referenceId;
  final DateTime createdAt;

  const NotificationApiModel({
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

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    return NotificationApiModel(
      id: json['_id'] as String,
      recipientId: json['recipientId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
      referenceId: json['referenceId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      recipientId: recipientId,
      senderId: senderId,
      senderName: senderName,
      type: type,
      title: title,
      message: message,
      isRead: isRead,
      referenceId: referenceId,
      createdAt: createdAt,
    );
  }
}
