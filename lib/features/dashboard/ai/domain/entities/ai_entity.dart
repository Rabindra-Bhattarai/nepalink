import 'package:equatable/equatable.dart';

class AiEntity extends Equatable {
  final String id;
  final String description;
  final String aiSummary;
  final DateTime date;
  final String status;
  final String memberName;
  final String nurseName;

  const AiEntity({
    required this.id,
    required this.description,
    required this.aiSummary,
    required this.date,
    required this.status,
    required this.memberName,
    required this.nurseName,
  });

  @override
  List<Object?> get props => [
    id,
    description,
    aiSummary,
    date,
    status,
    memberName,
    nurseName,
  ];
}
