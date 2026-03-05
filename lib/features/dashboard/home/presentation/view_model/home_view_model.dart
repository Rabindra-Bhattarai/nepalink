import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/dashboard/home/domain/usecases/get_assigned_activities_usecase.dart';
import 'package:nepalink/features/dashboard/home/presentation/state/home_state.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  final getActivities = ref.read(getAssignedActivitiesUsecaseProvider);
  return HomeViewModel(getActivities: getActivities);
});

class HomeViewModel extends StateNotifier<HomeState> {
  final GetAssignedActivitiesUsecase _getActivities;

  HomeViewModel({required GetAssignedActivitiesUsecase getActivities})
    : _getActivities = getActivities,
      super(const HomeState());

  Future<void> loadActivities() async {
    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);

    final result = await _getActivities();

    result.fold(
      (failure) => state = state.copyWith(
        status: HomeStatus.failure,
        errorMessage: failure.message,
      ),
      (activities) => state = state.copyWith(
        status: HomeStatus.success,
        activities: activities,
      ),
    );
  }
}
