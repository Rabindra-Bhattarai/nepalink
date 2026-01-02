import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/services/hive/hive_service.dart';

/// ====================== HIVE SERVICE PROVIDER ======================
/// Must be overridden in main.dart before runApp()

final hiveServiceProvider = Provider<HiveService>((ref) {
  throw UnimplementedError('hiveServiceProvider must be overridden');
});
