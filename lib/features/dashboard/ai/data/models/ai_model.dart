import 'package:nepalink/features/dashboard/ai/domain/entities/ai_entity.dart';

class AiModel {
  final String id;
  final String description;
  final String aiSummary;
  final DateTime date;
  final String status;
  final String memberName;
  final String nurseName;

  AiModel({
    required this.id,
    required this.description,
    required this.aiSummary,
    required this.date,
    required this.status,
    required this.memberName,
    required this.nurseName,
  });

  factory AiModel.fromJson(Map<String, dynamic> json) {
    final memberObj = json['memberId'];
    final nurseObj = json['nurseId'];

    return AiModel(
      id: json['_id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      aiSummary: json['aiSummary'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'pending',
      memberName: memberObj is Map ? memberObj['name'] as String? ?? '' : '',
      nurseName: nurseObj is Map ? nurseObj['name'] as String? ?? '' : '',
    );
  }

  AiEntity toEntity() {
    return AiEntity(
      id: id,
      description: description,
      aiSummary: aiSummary,
      date: date,
      status: status,
      memberName: memberName,
      nurseName: nurseName,
    );
  }
}
