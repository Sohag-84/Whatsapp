import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/presentation/cubit/message/message_cubit.dart';

class ChatUtils {
  static Future<void> sendMessage({
    required BuildContext context,
    required MessageEntity messageEntity,
    required String? message,
    required String? type,
    required String? repliedMessage,
    required String? repliedTo,
    required String? repliedMessageType,
  }) async {
    context.read<MessageCubit>().sendMessage(
      chatEntity: ChatEntity(
        senderUid: messageEntity.senderUid,
        recipientUid: messageEntity.recipientUid,
        senderName: messageEntity.senderName,
        recipientName: messageEntity.recipientName,
        senderProfile: messageEntity.senderProfile,
        recipientProfile: messageEntity.recipientProfile,
        createdAt: Timestamp.now(),
        totalUnReadMessages: 0,
      ),
      messageEntity: MessageEntity(
        senderUid: messageEntity.senderUid,
        recipientUid: messageEntity.recipientUid,
        senderName: messageEntity.senderName,
        recipientName: messageEntity.recipientName,
        messageType: type ?? "",
        repliedTo: repliedTo ?? "",
        repliedMessageType: repliedMessageType ?? "",
        repliedMessage: repliedMessage ?? "",
        isSeen: false,
        createdAt: Timestamp.now(),
        message: message,
      ),
    );
  }
}
