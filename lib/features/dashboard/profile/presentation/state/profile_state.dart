// lib/features/dashboard/profile/presentation/state/profile_state.dart

import 'package:equatable/equatable.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  final ProfileEntity? profile;
  final bool isLoading;
  final bool
  isUpdating; // separate flag for edit/upload so page doesn't flicker
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    isLoading,
    isUpdating,
    errorMessage,
    successMessage,
  ];
}
