import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_reply_entity.dart';
import 'package:whatsapp/features/chat/domain/usecases/delete_message_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/get_message_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/send_message_usecase.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final GetMessageUsecase getMessageUsecase;
  final DeleteMessageUsecase deleteMessageUsecase;
  final SendMessageUsecase sendMessageUsecase;
  MessageCubit({
    required this.getMessageUsecase,
    required this.deleteMessageUsecase,
    required this.sendMessageUsecase,
  }) : super(MessageInitial());

  Future<void> sendMessage({
    required ChatEntity chatEntity,
    required MessageEntity messageEntity,
  }) async {
    try {
      await sendMessageUsecase.call(
        chatEntity: chatEntity,
        messageEntity: messageEntity,
      );
    } on SocketException {
      emit(MessageFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(MessageFailure(error: e.toString()));
    }
  }

  Future<void> getMessages({required MessageEntity messageEntity}) async {
    try {
      emit(MessageLoading());
      final messageStream = getMessageUsecase.call(
        messageEntity: messageEntity,
      );
      messageStream.listen((messages) {
        emit(MessageLoaded(messages: messages));
      });
    } on SocketException {
      emit(MessageFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(MessageFailure(error: e.toString()));
    }
  }

  Future<void> deleteMessage({required MessageEntity messageEntity}) async {
    try {
      await deleteMessageUsecase.call(messageEntity: messageEntity);
    } on SocketException {
      emit(MessageFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(MessageFailure(error: e.toString()));
    }
  }

  MessageReplayEntity messageReplay = MessageReplayEntity();

  MessageReplayEntity get getMessageReplay => MessageReplayEntity();

  set setMessageReplay(MessageReplayEntity messageReplay) {
    this.messageReplay = messageReplay;
  }
}
