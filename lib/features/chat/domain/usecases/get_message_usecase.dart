import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';

class GetMessageUsecase {
  final ChatRepository chatRepository;
  const GetMessageUsecase({required this.chatRepository});

  Stream<List<MessageEntity>> call({required MessageEntity messageEntity}) {
    return chatRepository.getMessages(messageEntity: messageEntity);
  }
}
