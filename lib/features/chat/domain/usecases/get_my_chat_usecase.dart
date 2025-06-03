import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';

class GetMyChatUsecase {
  final ChatRepository chatRepository;
  const GetMyChatUsecase({required this.chatRepository});

  Stream<List<ChatEntity>> call({required ChatEntity chatEntity}) {
    return chatRepository.getMyChat(chatEntity: chatEntity);
  }
}
