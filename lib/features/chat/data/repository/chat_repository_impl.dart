import 'package:whatsapp/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;
  const ChatRepositoryImpl({required this.chatRemoteDataSource});

  @override
  Future<void> deleteChat({required ChatEntity chatEntity}) async {
    return await chatRemoteDataSource.deleteChat(chatEntity: chatEntity);
  }

  @override
  Future<void> deleteMessage({required MessageEntity messageEntity}) async {
    return await chatRemoteDataSource.deleteMessage(
      messageEntity: messageEntity,
    );
  }

  @override
  Stream<List<MessageEntity>> getMessages({
    required MessageEntity messageEntity,
  }) {
    return chatRemoteDataSource.getMessages(messageEntity: messageEntity);
  }

  @override
  Stream<List<ChatEntity>> getMyChat({required ChatEntity chatEntity}) {
    return chatRemoteDataSource.getMyChat(chatEntity: chatEntity);
  }

  @override
  Future<void> sendMessage({
    required ChatEntity chatEntity,
    required MessageEntity messageEntity,
  }) async {
    return await chatRemoteDataSource.sendMessage(
      chatEntity: chatEntity,
      messageEntity: messageEntity,
    );
  }
}
