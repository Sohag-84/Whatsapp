import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/core/const/firebase_collection_const.dart';
import 'package:whatsapp/core/const/message_type_const.dart';
import 'package:whatsapp/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:whatsapp/features/chat/data/models/chat_model.dart';
import 'package:whatsapp/features/chat/data/models/message_model.dart';
import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  const ChatRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> sendMessage({
    required ChatEntity chatEntity,
    required MessageEntity messageEntity,
  }) async {
    await sendMessageBasedOnType(messageEntity: messageEntity);
    String recentTextMessage = "";

    switch (messageEntity.messageType) {
      case MessageTypeConst.photoMessage:
        recentTextMessage = '📷 Photo';
        break;
      case MessageTypeConst.videoMessage:
        recentTextMessage = '📸 Video';
        break;
      case MessageTypeConst.audioMessage:
        recentTextMessage = '🎵 Audio';
        break;
      case MessageTypeConst.gifMessage:
        recentTextMessage = 'GIF';
        break;
      default:
        recentTextMessage = messageEntity.message!;
    }
    await addToChat(
      chatEntity: ChatEntity(
        createdAt: chatEntity.createdAt,
        senderProfile: chatEntity.senderProfile,
        recipientProfile: chatEntity.recipientProfile,
        recentTextMessage: recentTextMessage,
        recipientName: chatEntity.recipientName,
        senderName: chatEntity.senderName,
        recipientUid: chatEntity.recipientUid,
        senderUid: chatEntity.senderUid,
        totalUnReadMessages: chatEntity.totalUnReadMessages,
      ),
    );
  }

  Future<void> addToChat({required ChatEntity chatEntity}) async {
    // users -> uid -> myChat -> uid -> messages -> messageIds

    final myChatRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(chatEntity.senderUid)
        .collection(FirebaseCollectionConst.myChat);

    final otherChatRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(chatEntity.recipientUid)
        .collection(FirebaseCollectionConst.myChat);

    final myNewChat =
        ChatModel(
          createdAt: chatEntity.createdAt,
          senderProfile: chatEntity.senderProfile,
          recipientProfile: chatEntity.recipientProfile,
          recentTextMessage: chatEntity.recentTextMessage,
          recipientName: chatEntity.recipientName,
          senderName: chatEntity.senderName,
          recipientUid: chatEntity.recipientUid,
          senderUid: chatEntity.senderUid,
          totalUnReadMessages: chatEntity.totalUnReadMessages,
        ).toDocument();

    final otherNewChat =
        ChatModel(
          createdAt: chatEntity.createdAt,
          senderProfile: chatEntity.recipientProfile,
          recipientProfile: chatEntity.senderProfile,
          recentTextMessage: chatEntity.recentTextMessage,
          recipientName: chatEntity.senderName,
          senderName: chatEntity.recipientName,
          recipientUid: chatEntity.senderUid,
          senderUid: chatEntity.recipientUid,
          totalUnReadMessages: chatEntity.totalUnReadMessages,
        ).toDocument();

    try {
      myChatRef.doc(chatEntity.recipientUid).get().then((myChatDoc) async {
        // Create
        if (!myChatDoc.exists) {
          await myChatRef.doc(chatEntity.recipientUid).set(myNewChat);
          await otherChatRef.doc(chatEntity.senderUid).set(otherNewChat);
          return;
        } else {
          // Update
          await myChatRef.doc(chatEntity.recipientUid).update(myNewChat);
          await otherChatRef.doc(chatEntity.senderUid).update(otherNewChat);
          return;
        }
      });
    } catch (e) {
      debugPrint("error occur while adding to chat");
    }
  }

  Future<void> sendMessageBasedOnType({
    required MessageEntity messageEntity,
  }) async {
    // users -> uid -> myChat -> uid -> messages -> messageIds

    final myMessageRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(messageEntity.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(messageEntity.recipientUid)
        .collection(FirebaseCollectionConst.messages);

    final otherMessageRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(messageEntity.recipientUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(messageEntity.senderUid)
        .collection(FirebaseCollectionConst.messages);

    String messageId = const Uuid().v1();

    final newMessage =
        MessageModel(
          senderUid: messageEntity.senderUid,
          recipientUid: messageEntity.recipientUid,
          senderName: messageEntity.senderName,
          recipientName: messageEntity.recipientName,
          createdAt: messageEntity.createdAt,
          repliedTo: messageEntity.repliedTo,
          repliedMessage: messageEntity.repliedMessage,
          isSeen: messageEntity.isSeen,
          messageType: messageEntity.messageType,
          message: messageEntity.message,
          messageId: messageId,
          repliedMessageType: messageEntity.repliedMessageType,
        ).toDocument();

    try {
      await myMessageRef.doc(messageId).set(newMessage);
      await otherMessageRef.doc(messageId).set(newMessage);
    } catch (e) {
      debugPrint("error occur while sending message");
    }
  }

  @override
  Future<void> deleteChat({required ChatEntity chatEntity}) async {
    final chatRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(chatEntity.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(chatEntity.recipientUid);

    try {
      await chatRef.delete();
    } catch (e) {
      debugPrint("error occur while deleting chat conversation $e");
    }
  }

  @override
  Future<void> deleteMessage({required MessageEntity messageEntity}) async {
    final messageRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(messageEntity.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(messageEntity.recipientUid)
        .collection(FirebaseCollectionConst.messages)
        .doc(messageEntity.messageId);
    try {
      await messageRef.delete();
    } catch (e) {
      debugPrint("error occur while deleting chat conversation $e");
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages({
    required MessageEntity messageEntity,
  }) {
    final messagesRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(messageEntity.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(messageEntity.recipientUid)
        .collection(FirebaseCollectionConst.messages)
        .orderBy("createdAt", descending: false);

    return messagesRef.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => MessageModel.fromSnapshot(e)).toList(),
    );
  }

  @override
  Stream<List<ChatEntity>> getMyChat({required ChatEntity chatEntity}) {
    final myChatRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(chatEntity.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .orderBy("createdAt", descending: true);

    return myChatRef.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => ChatModel.fromSnapshot(e)).toList(),
    );
  }
}
