import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';

class DeleteMessageUsecase {
  final ChatRepository chatRepository;
  const DeleteMessageUsecase({required this.chatRepository});

  Future<void> call({required MessageEntity messageEntity}) {
    return chatRepository.deleteMessage(messageEntity: messageEntity);
  }
}
