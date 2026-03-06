import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/services/connectivity/network_info.dart';
import 'package:nepalink/features/dashboard/chat/data/datasources/local/chat_local_datasource.dart';
import 'package:nepalink/features/dashboard/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';
import 'package:nepalink/features/dashboard/chat/domain/repositories/chat_repository.dart';
import 'package:nepalink/features/dashboard/chat/data/datasources/chat_datasource.dart';

final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  final local = ref.read(chatLocalDatasourceProvider);
  final remote = ref.read(chatRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ChatRepositoryImpl(
    localDataSource: local,
    remoteDataSource: remote,
    networkInfo: networkInfo,
  );
});

class ChatRepositoryImpl implements IChatRepository {
  final IChatLocalDataSource _local;
  final IChatRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  ChatRepositoryImpl({
    required IChatLocalDataSource localDataSource,
    required IChatRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _local = localDataSource,
       _remote = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages(
    String contractId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final messages = await _remote.getMessages(contractId);
        // ✅ Save messages locally for offline use
        for (var msg in messages) {
          await _local.saveMessage(msg);
        }
        return Right(messages);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final messages = await _local.getMessages(contractId);
        return Right(messages);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String contractId,
    required String receiverId,
    required String message,
    List<String>? attachments,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final sentMessage = await _remote.sendMessage(
          contractId: contractId,
          receiverId: receiverId,
          message: message,
          attachments: attachments,
        );
        // ✅ Save locally
        await _local.saveMessage(sentMessage);
        return Right(sentMessage);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // Offline mode: create a local-only message
      final offlineMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        contractId: contractId,
        senderId: "local_user", // placeholder until sync
        receiverId: receiverId,
        message: message,
        isRead: false,
        attachments: attachments,
        createdAt: DateTime.now(),
      );
      await _local.saveMessage(offlineMessage);
      return Right(offlineMessage);
    }
  }

  @override
  Future<Either<Failure, bool>> markMessagesRead(String contractId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remote.markMessagesRead(contractId);
        await _local.markMessagesRead(contractId);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        await _local.markMessagesRead(contractId);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
