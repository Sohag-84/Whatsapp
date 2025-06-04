part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

final class ChatFailure extends ChatState {
  final String error;
  const ChatFailure({required this.error});

  @override
  List<Object> get props =>[error];
}
