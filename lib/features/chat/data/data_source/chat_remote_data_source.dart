import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';

abstract interface class ChatRemoteDataSource {
  Future<void> sendMessage({
    required ChatEntity chatEntity,
    required MessageEntity messageEntity,
  });

  Stream<List<ChatEntity>> getMyChat({required ChatEntity chatEntity});
  Stream<List<MessageEntity>> getMessages({
    required MessageEntity messageEntity,
  });

  Future<void> deleteMessage({required MessageEntity messageEntity});
  Future<void> deleteChat({required ChatEntity chatEntity});
  Future<void> seenMessageUpdate({required MessageEntity messageEntity});
}
