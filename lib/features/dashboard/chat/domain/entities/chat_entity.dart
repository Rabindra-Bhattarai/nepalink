import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String contractId;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isRead;
  final List<String>? attachments;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.id,
    required this.contractId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    this.attachments,
    required this.createdAt,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    // contractId can be a string or a nested object
    final contract = json['contractId'];
    final contractId = (contract is Map)
        ? contract['_id']?.toString() ?? ''
        : contract?.toString() ?? '';

    // ✅ FIX: senderId comes as a nested object {_id, name, role}
    // Extract just the _id string from it
    final senderRaw = json['senderId'];
    final senderId = (senderRaw is Map)
        ? senderRaw['_id']?.toString() ?? ''
        : senderRaw?.toString() ?? '';

    // ✅ FIX: receiverId same issue
    final receiverRaw = json['receiverId'];
    final receiverId = (receiverRaw is Map)
        ? receiverRaw['_id']?.toString() ?? ''
        : receiverRaw?.toString() ?? '';

    return ChatMessageEntity(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      contractId: contractId,
      senderId: senderId,
      receiverId: receiverId,
      message: json['message'] is String
          ? json['message'] as String
          : (json['message']?['text']?.toString() ?? ''),
      isRead: json['isRead'] == true,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractId': contractId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'isRead': isRead,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ChatMessageEntity copyWith({
    String? id,
    String? contractId,
    String? senderId,
    String? receiverId,
    String? message,
    bool? isRead,
    List<String>? attachments,
    DateTime? createdAt,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    contractId,
    senderId,
    receiverId,
    message,
    isRead,
    attachments,
    createdAt,
  ];
}
