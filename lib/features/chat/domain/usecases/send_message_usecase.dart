import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository chatRepository;
  const SendMessageUsecase(this.chatRepository);

  Future<void> call({
    required ChatEntity chatEntity,
    required MessageEntity messageEntity,
  }) {
    return chatRepository.sendMessage(
      chatEntity: chatEntity,
      messageEntity: messageEntity,
    );
  }
}
