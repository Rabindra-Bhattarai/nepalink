import 'package:equatable/equatable.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ActivityEntity> activities;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.activities = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ActivityEntity>? activities,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // ── Derived helpers used by the UI / charts ──

  /// Activities sorted newest first
  List<ActivityEntity> get sorted =>
      [...activities]..sort((a, b) => b.date.compareTo(a.date));

  /// Last 7 days of activities for charts
  List<ActivityEntity> get lastSevenDays {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return sorted.where((a) => a.date.isAfter(cutoff)).toList();
  }

  int get completedCount =>
      activities.where((a) => a.status == 'completed').length;
  int get pendingCount => activities.where((a) => a.status == 'pending').length;
  int get cancelledCount =>
      activities.where((a) => a.status == 'cancelled').length;

  @override
  List<Object?> get props => [status, activities, errorMessage];
}
