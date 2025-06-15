import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';

class SeenMessageUpdateUsecase {
  final ChatRepository chatRepository;
  const SeenMessageUpdateUsecase({required this.chatRepository});

  Future<void> call({required MessageEntity messageEntity}) async {
    await chatRepository.seenMessageUpdate(messageEntity: messageEntity);
  }
}
