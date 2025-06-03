import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';

class DeleteMyChatUsecase {
  final ChatRepository chatRepository;
  const DeleteMyChatUsecase({required this.chatRepository});

  Future<void> call({required ChatEntity chatEntity}) {
    return chatRepository.deleteChat(chatEntity: chatEntity);
  }
}
