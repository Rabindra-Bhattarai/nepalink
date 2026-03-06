import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/profile/data/datasources/profile_datasource.dart';
import 'package:nepalink/features/dashboard/profile/data/models/profile_hive_model.dart';

final profileLocalDataSourceProvider = Provider<IProfileLocalDataSource>(
  (ref) => ProfileLocalDataSource(),
);

class ProfileLocalDataSource implements IProfileLocalDataSource {
  // Uses HiveTableConstant — consistent with HiveService
  Box<ProfileHiveModel> get _box =>
      Hive.box<ProfileHiveModel>(HiveTableConstant.profileTable);

  @override
  Future<ProfileHiveModel?> getProfile() async {
    return _box.values.isNotEmpty ? _box.values.first : null;
  }

  @override
  Future<void> saveProfile(ProfileHiveModel profile) async {
    await _box.put(profile.id, profile);
  }

  @override
  Future<void> clearProfile() async {
    await _box.clear();
  }
}
