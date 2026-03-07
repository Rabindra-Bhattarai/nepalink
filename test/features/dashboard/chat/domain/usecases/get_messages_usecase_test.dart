import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';
import 'package:nepalink/features/dashboard/chat/domain/repositories/chat_repository.dart';
import 'package:nepalink/features/dashboard/chat/domain/usecases/get_messages_usecase.dart';

@GenerateMocks([IChatRepository])
import 'get_messages_usecase_test.mocks.dart';

void main() {
  late GetMessagesUsecase getMessagesUsecase;
  late MockIChatRepository mockChatRepository;

  final tMessages = [
    ChatMessageEntity(
      id: 'msg-001',
      contractId: 'contract-001',
      senderId: 'nurse-001',
      receiverId: 'member-001',
      message: 'Hello, how are you feeling today?',
      isRead: false,
      attachments: [],
      createdAt: DateTime(2025, 3, 10, 9, 0),
    ),
    ChatMessageEntity(
      id: 'msg-002',
      contractId: 'contract-001',
      senderId: 'member-001',
      receiverId: 'nurse-001',
      message: 'I am feeling better, thank you.',
      isRead: true,
      attachments: [],
      createdAt: DateTime(2025, 3, 10, 9, 5),
    ),
  ];

  setUp(() {
    mockChatRepository = MockIChatRepository();
    getMessagesUsecase = GetMessagesUsecase(mockChatRepository);
  });

  group('GetMessagesUsecase', () {
    test('returns list of messages for a valid contract id', () async {
      when(
        mockChatRepository.getMessages(any),
      ).thenAnswer((_) async => Right(tMessages));

      final result = await getMessagesUsecase(
        const GetMessagesParams('contract-001'),
      );

      expect(result, Right(tMessages));
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('expected success but got failure'),
        (messages) => expect(messages.length, 2),
      );
      verify(mockChatRepository.getMessages('contract-001')).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('returns ApiFailure when fetching messages fails', () async {
      when(mockChatRepository.getMessages(any)).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Failed to fetch messages')),
      );

      final result = await getMessagesUsecase(
        const GetMessagesParams('contract-001'),
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Failed to fetch messages'),
        (_) => fail('expected failure but got success'),
      );
      verify(mockChatRepository.getMessages('contract-001')).called(1);
    });
  });
}
