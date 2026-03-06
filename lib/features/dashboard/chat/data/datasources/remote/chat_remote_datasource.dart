import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/chat/data/datasources/chat_datasource.dart';
import 'package:nepalink/features/dashboard/chat/data/models/chat_api_model.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';

final chatRemoteDatasourceProvider = Provider<IChatRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ChatRemoteDatasource(apiClient.dio);
});

class ChatRemoteDatasource implements IChatRemoteDataSource {
  final Dio _dio;
  ChatRemoteDatasource(this._dio);

  @override
  Future<List<ChatMessageEntity>> getMessages(String contractId) async {
    final response = await _dio.get(ApiEndpoints.chatMessages(contractId));
    final data = response.data['data'] as List<dynamic>;
    return data.map((json) => ChatApiModel.fromJson(json).toEntity()).toList();
  }

  @override
  Future<ChatMessageEntity> sendMessage({
    required String contractId,
    required String receiverId,
    required String message,
    List<String>? attachments,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.chatSend(contractId),
      data: {
        "receiverId": receiverId,
        "message": message,
        "attachments": attachments,
      },
    );
    final json = response.data['data'] as Map<String, dynamic>;
    return ChatApiModel.fromJson(json).toEntity();
  }

  @override
  Future<bool> markMessagesRead(String contractId) async {
    final response = await _dio.patch(ApiEndpoints.chatMarkRead(contractId));
    return response.data['success'] == true;
  }
}
