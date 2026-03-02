import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/services/connectivity/network_info.dart';
import 'package:nepalink/features/dashboard/booking/data/datasources/local/booking_local_datasource.dart';
import 'package:nepalink/features/dashboard/booking/data/datasources/remote/booking_remote_datasource.dart';
import 'package:nepalink/features/dashboard/booking/data/repositories/booking_repository_impl.dart';
import 'package:nepalink/features/dashboard/booking/domain/repositories/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final remote = ref.read(bookingRemoteDatasourceProvider);
  final local = ref.read(bookingLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return BookingRepositoryImpl(
    remoteDatasource: remote,
    localDatasource: local,
    networkInfo: networkInfo,
  );
});
