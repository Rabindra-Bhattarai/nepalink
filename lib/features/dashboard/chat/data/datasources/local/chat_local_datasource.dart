import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/providers/hive_provider.dart';
import 'package:nepalink/core/services/hive/hive_service.dart';
import 'package:nepalink/features/dashboard/chat/data/datasources/chat_datasource.dart';
import 'package:nepalink/features/dashboard/chat/data/models/chat_hive_model.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';

final chatLocalDatasourceProvider = Provider<IChatLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ChatLocalDatasource(hiveService);
});

class ChatLocalDatasource implements IChatLocalDataSource {
  final HiveService _hiveService;
  ChatLocalDatasource(this._hiveService);

  @override
  Future<void> saveMessage(ChatMessageEntity message) async {
    final hiveModel = ChatHiveModel.fromEntity(message);
    await _hiveService.saveChatMessage(hiveModel);
  }

  @override
  Future<List<ChatMessageEntity>> getMessages(String contractId) async {
    final hiveModels = _hiveService.getMessagesByContract(contractId);
    return hiveModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> markMessagesRead(String contractId) async {
    await _hiveService.markMessagesRead(contractId);
  }
}
