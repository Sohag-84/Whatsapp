import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/usecases/delete_my_chat_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/get_my_chat_usecase.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMyChatUsecase getMyChatUsecase;
  final DeleteMyChatUsecase deleteMyChatUsecase;
  ChatCubit({required this.getMyChatUsecase, required this.deleteMyChatUsecase})
    : super(ChatInitial());

  Future<void> getMyChat({required ChatEntity chatEntity}) async {
    try {
      emit(ChatLoading());
      final streamResponse = getMyChatUsecase.call(chatEntity: chatEntity);
      streamResponse.listen((chatContacts) {
        emit(ChatLoaded(chats: chatContacts));
      });
    } on SocketException {
      emit(ChatFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(ChatFailure(error: e.toString()));
    }
  }

  Future<void> deleteMyChat({required ChatEntity chatEntity}) async {
    try { 
      await deleteMyChatUsecase.call(chatEntity: chatEntity);
    } on SocketException {
      emit(ChatFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(ChatFailure(error: e.toString()));
    }
  }
}
