import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';

part 'chat_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.chatTypeId)
class ChatHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String contractId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String receiverId;

  @HiveField(4)
  final String message;

  @HiveField(5)
  final bool isRead;

  @HiveField(6)
  final List<String>? attachments;

  @HiveField(7)
  final DateTime createdAt;

  ChatHiveModel({
    String? id,
    required this.contractId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    this.attachments,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  /// Convert Hive model to domain entity
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      contractId: contractId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      isRead: isRead,
      attachments: attachments,
      createdAt: createdAt,
    );
  }

  /// Create Hive model from domain entity
  factory ChatHiveModel.fromEntity(ChatMessageEntity entity) {
    return ChatHiveModel(
      id: entity.id,
      contractId: entity.contractId,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      message: entity.message,
      isRead: entity.isRead,
      attachments: entity.attachments,
      createdAt: entity.createdAt,
    );
  }
}
