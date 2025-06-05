import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/core/global/widgets/loader.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/presentation/cubit/message/message_cubit.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity messageEntity;
  const SingleChatPage({super.key, required this.messageEntity});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final _textMessageController = TextEditingController();
  bool isDisplaySendButton = false;
  bool isShowAttachWindow = false;

  @override
  void initState() {
    BlocProvider.of<MessageCubit>(context).getMessages(
      messageEntity: MessageEntity(
        senderUid: widget.messageEntity.senderUid,
        recipientUid: widget.messageEntity.recipientUid,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _textMessageController.dispose;
    super.dispose;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.messageEntity.recipientName ?? ""),
            Text(
              "Online",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.videocam_rounded, size: 25),
          ),
          const SizedBox(width: 25),
          const Icon(Icons.call, size: 22),
          const SizedBox(width: 25),
          const Icon(Icons.more_vert, size: 22),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return loader();
          }
          if (state is MessageLoaded) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  isShowAttachWindow = false;
                });
              },
              child: Stack(
                children: [
                  ///background image
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Image.asset(
                      "assets/whatsapp_bg_image.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    children: [
                      ///message list
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final message = state.messages[index];
                            if (message.senderUid ==
                                widget.messageEntity.senderUid) {
                              return _messageLayout(
                                message: message.message,
                                alignment: Alignment.centerRight,
                                createAt: message.createdAt,
                                isSeen: false,
                                isShowTick: true,
                                messageBgColor: messageColor,
                                onLongPress: () {},
                                onSwipe: () {},
                              );
                            } else {
                              return _messageLayout(
                                message: message.message,
                                alignment: Alignment.centerLeft,
                                createAt: message.createdAt,
                                isSeen: false,
                                isShowTick: false,
                                messageBgColor: senderMessageColor,
                                onLongPress: () {},
                                onSwipe: () {},
                              );
                            }
                          },
                        ),
                      ),

                      ///message type field
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            ///textfield
                            Expanded(
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: appBarColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextField(
                                  controller: _textMessageController,
                                  onTap: () {
                                    setState(() {
                                      isShowAttachWindow = false;
                                    });
                                  },
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        isDisplaySendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        isDisplaySendButton = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Message",
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.emoji_emotions,
                                      color: greyColor,
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Wrap(
                                        children: [
                                          Transform.rotate(
                                            angle: -0.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                isShowAttachWindow =
                                                    !isShowAttachWindow;
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.attach_file,
                                                color: greyColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Icon(
                                            Icons.camera_alt,
                                            color: greyColor,
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            ///send and voice record button
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: tabColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Icon(
                                  isDisplaySendButton
                                      ? Icons.send_outlined
                                      : Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  ///emoji window
                  isShowAttachWindow
                      ? Positioned(
                        left: 15,
                        top: 340,
                        right: 15,
                        bottom: 65,
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * 0.20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: bottomAttachContainerColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _attachWindowItem(
                                    icon: Icons.document_scanner,
                                    color: Colors.deepPurpleAccent,
                                    title: "Document",
                                  ),
                                  _attachWindowItem(
                                    icon: Icons.camera_alt,
                                    color: Colors.pinkAccent,
                                    title: "Camera",
                                    onTap: () {},
                                  ),
                                  _attachWindowItem(
                                    icon: Icons.image,
                                    color: Colors.purpleAccent,
                                    title: "Gallery",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _attachWindowItem(
                                    icon: Icons.headphones,
                                    color: Colors.deepOrange,
                                    title: "Audio",
                                  ),
                                  _attachWindowItem(
                                    icon: Icons.location_on,
                                    color: Colors.green,
                                    title: "Location",
                                  ),
                                  _attachWindowItem(
                                    icon: Icons.account_circle,
                                    color: Colors.deepPurpleAccent,
                                    title: "Contact",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _attachWindowItem(
                                    icon: Icons.bar_chart,
                                    color: tabColor,
                                    title: "Poll",
                                  ),
                                  _attachWindowItem(
                                    icon: Icons.gif_box_outlined,
                                    color: Colors.indigoAccent,
                                    title: "Gif",
                                    onTap: () {},
                                  ),
                                  _attachWindowItem(
                                    icon: Icons.videocam_rounded,
                                    color: Colors.lightGreen,
                                    title: "Video",
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      : Container(),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  _messageLayout({
    Color? messageBgColor,
    Alignment? alignment,
    Timestamp? createAt,
    VoidCallback? onSwipe,
    String? message,
    bool? isShowTick,
    bool? isSeen,
    VoidCallback? onLongPress,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SwipeTo(
        onRightSwipe: (value) => onSwipe,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            alignment: alignment,
            child: Stack(
              children: [
                ///message text
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 85,
                        top: 5,
                        bottom: 5,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.80,
                      ),
                      decoration: BoxDecoration(
                        color: messageBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$message",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    SizedBox(height: 3),
                  ],
                ),

                ///sent time, check seen or unseen message
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        DateFormat.jm().format(createAt!.toDate()),
                        style: const TextStyle(fontSize: 12, color: greyColor),
                      ),
                      const SizedBox(width: 5),
                      isShowTick == true
                          ? Icon(
                            isSeen == true ? Icons.done_all : Icons.done,
                            size: 16,
                            color: isSeen == true ? Colors.blue : greyColor,
                          )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _attachWindowItem({
    IconData? icon,
    Color? color,
    String? title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: color,
            ),
            child: Center(child: Icon(icon, size: 20)),
          ),
          const SizedBox(height: 5),
          Text("$title", style: const TextStyle(color: greyColor, fontSize: 9)),
        ],
      ),
    );
  }
}
