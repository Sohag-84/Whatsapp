import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/core/global/widgets/loader.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/presentation/cubit/chat/chat_cubit.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  const ChatPage({super.key, required this.uid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    context.read<ChatCubit>().getMyChat(
      chatEntity: ChatEntity(senderUid: widget.uid),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return loader();
          }
          if (state is ChatLoaded) {
            if (state.chats.isEmpty) {
              return Center(
                child: Text(
                  "No Conversation Yet",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (BuildContext context, int index) {
                final chat = state.chats[index];
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageConst.singleChatPage,
                      arguments: MessageEntity(
                        senderUid: chat.senderUid,
                        recipientUid: chat.recipientUid,
                        senderName: chat.senderName,
                        recipientName: chat.recipientName,
                        senderProfile: chat.senderProfile,
                        recipientProfile: chat.recipientProfile,
                        uid: widget.uid,
                      ),
                    );
                  },
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: profileWidget(),
                    ),
                  ),
                  title: Text(chat.recipientName ?? ""),
                  subtitle: Text(
                    chat.recentTextMessage ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    DateFormat.jm().format(chat.createdAt!.toDate()),
                    style: const TextStyle(color: greyColor, fontSize: 13),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
