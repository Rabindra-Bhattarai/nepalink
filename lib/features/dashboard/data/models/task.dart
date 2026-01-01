class Task {
  final String title;
  final DateTime dateTime;
  final String caregiver;
  final String category;
  final bool isCompleted;
  final bool isOverdue;

  Task({
    required this.title,
    required this.dateTime,
    required this.caregiver,
    required this.category,
    this.isCompleted = false,
    this.isOverdue = false,
  });
}
