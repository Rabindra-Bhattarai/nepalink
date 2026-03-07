import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';
import 'package:nepalink/features/dashboard/booking/domain/repositories/booking_repository.dart';
import 'package:nepalink/features/dashboard/booking/domain/usecases/accept_booking_usecase.dart';

@GenerateMocks([BookingRepository])
import 'accept_booking_usecase_test.mocks.dart';

void main() {
  late AcceptBookingUsecase acceptBookingUsecase;
  late MockBookingRepository mockBookingRepository;

  final tBookingEntity = BookingEntity(
    id: 'booking-001',
    memberId: 'member-001',
    nurseId: 'nurse-001',
    contractId: 'contract-001',
    memberName: 'Ram Bahadur',
    memberPhone: '+9779800000001',
    profilePic: '',
    bookingDate: DateTime(2025, 3, 10),
    status: 'accepted',
  );

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    acceptBookingUsecase = AcceptBookingUsecase(mockBookingRepository);
  });

  group('AcceptBookingUsecase', () {
    test('returns BookingEntity with accepted status on success', () async {
      when(
        mockBookingRepository.acceptBooking(any),
      ).thenAnswer((_) async => tBookingEntity);

      final result = await acceptBookingUsecase('booking-001');

      expect(result, tBookingEntity);
      expect(result.status, 'accepted');
      verify(mockBookingRepository.acceptBooking('booking-001')).called(1);
      verifyNoMoreInteractions(mockBookingRepository);
    });

    test('throws exception when booking id does not exist', () async {
      when(
        mockBookingRepository.acceptBooking(any),
      ).thenThrow(Exception('Booking not found'));

      expect(
        () async => await acceptBookingUsecase('invalid-id'),
        throwsException,
      );
      verify(mockBookingRepository.acceptBooking('invalid-id')).called(1);
    });
  });
}
