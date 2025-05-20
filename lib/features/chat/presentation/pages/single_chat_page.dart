import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/core/theme/style.dart';

class SingleChatPage extends StatefulWidget {
  const SingleChatPage({super.key});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final _textMessageController = TextEditingController();
  bool isDisplaySendButton = false;

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
            Text('Raiyan'),
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
      body: Stack(
        children: [
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
                child: ListView(
                  children: [
                    _messageLayout(
                      message: "Hello",
                      alignment: Alignment.centerRight,
                      createAt: Timestamp.now(),
                      isSeen: false,
                      isShowTick: true,
                      messageBgColor: messageColor,
                      onLongPress: () {},
                      onSwipe: () {},
                    ),
                    _messageLayout(
                      message: "How are you?",
                      alignment: Alignment.centerRight,
                      createAt: Timestamp.now(),
                      isSeen: true,
                      isShowTick: true,
                      messageBgColor: messageColor,
                      onLongPress: () {},
                      onSwipe: () {},
                    ),
                    _messageLayout(
                      message: "I am fine. How about you?",
                      alignment: Alignment.centerLeft,
                      createAt: Timestamp.now(),
                      isSeen: false,
                      isShowTick: false,
                      messageBgColor: senderMessageColor,
                      onLongPress: () {},
                      onSwipe: () {},
                    ),
                  ],
                ),
              ),

              ///message type field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    ///textfield
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _textMessageController,
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
                                    child: Icon(
                                      Icons.attach_file,
                                      color: greyColor,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Icon(Icons.camera_alt, color: greyColor),
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
                          isDisplaySendButton ? Icons.send_outlined : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _messageLayout({
    Color? messageBgColor,
    Alignment? alignment,
    Timestamp? createAt,
    VoidCallback? onSwipe,
    String? message,
    String? messageType,
    bool? isShowTick,
    bool? isSeen,
    VoidCallback? onLongPress,
    double? rightPadding,
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
}
