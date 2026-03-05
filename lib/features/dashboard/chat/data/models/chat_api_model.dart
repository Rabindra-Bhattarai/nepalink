import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';

class ChatApiModel {
  final String id;
  final String contractId;
  final String senderId;
  final String receiverId;
  final String message;
  final bool isRead;
  final List<String>? attachments;
  final DateTime createdAt;

  ChatApiModel({
    required this.id,
    required this.contractId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    this.attachments,
    required this.createdAt,
  });

  /// Extracts a clean MongoDB _id string from:
  ///   - a plain string:       "69a96c4a4af16cad9febba0b"
  ///   - a nested Map:         { "_id": "69a96c4a...", "name": "kiran", "role": "nurse" }
  ///   - a stringified object: "{_id: 69a96c4a..., name: kiran rana, role: nurse}"
  static String _extractId(dynamic raw) {
    if (raw == null) return '';

    // Proper nested Map → pull _id directly
    if (raw is Map) {
      return raw['_id']?.toString() ?? raw['id']?.toString() ?? '';
    }

    final str = raw.toString().trim();

    // Already a clean 24-char hex ObjectId
    if (RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(str)) return str;

    // Stringified map — extract 24-char hex after "_id:"
    final match = RegExp(r'_id:\s*([a-fA-F0-9]{24})').firstMatch(str);
    if (match != null) return match.group(1)!;

    return str;
  }

  factory ChatApiModel.fromJson(Map<String, dynamic> json) {
    final contract = json['contractId'];
    final contractId = _extractId(contract);

    return ChatApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      contractId: contractId,
      senderId: _extractId(json['senderId']), // ✅ fixed
      receiverId: _extractId(json['receiverId']), // ✅ fixed
      message: json['message']?.toString() ?? '',
      isRead: json['isRead'] == true,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

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

  factory ChatApiModel.fromEntity(ChatMessageEntity entity) {
    return ChatApiModel(
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

  Map<String, dynamic> toJson() {
    return {
      "contractId": contractId,
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "attachments": attachments,
    };
  }
}
