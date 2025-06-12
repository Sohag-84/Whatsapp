import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/core/const/app_const.dart';
import 'package:whatsapp/core/const/message_type_const.dart';
import 'package:whatsapp/core/global/widgets/loader.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:whatsapp/features/chat/presentation/widgets/attach_window_item.dart';
import 'package:whatsapp/features/chat/presentation/widgets/chat_utils.dart';
import 'package:whatsapp/features/chat/presentation/widgets/message_layout.dart';
import 'package:whatsapp/storage/storage_provider.dart';

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

  File? image;

  Future selectImage() async {
    setState(() => image = null);
    try {
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );

      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  File? video;

  Future selectVideo() async {
    setState(() => image = null);
    try {
      final pickedFile = await ImagePicker.platform.getVideo(
        source: ImageSource.gallery,
      );

      setState(() {
        if (pickedFile != null) {
          video = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

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
                              return messageLayout(
                                context: context,
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
                              return messageLayout(
                                context: context,
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

                            ///send message and voice record button
                            GestureDetector(
                              onTap: () async {},
                              child: Container(
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
                                  attachWindowItem(
                                    icon: Icons.document_scanner,
                                    color: Colors.deepPurpleAccent,
                                    title: "Document",
                                  ),
                                  attachWindowItem(
                                    icon: Icons.camera_alt,
                                    color: Colors.pinkAccent,
                                    title: "Camera",
                                    onTap: () {},
                                  ),
                                  attachWindowItem(
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
                                  attachWindowItem(
                                    icon: Icons.headphones,
                                    color: Colors.deepOrange,
                                    title: "Audio",
                                  ),
                                  attachWindowItem(
                                    icon: Icons.location_on,
                                    color: Colors.green,
                                    title: "Location",
                                  ),
                                  attachWindowItem(
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
                                  attachWindowItem(
                                    icon: Icons.bar_chart,
                                    color: tabColor,
                                    title: "Poll",
                                  ),
                                  attachWindowItem(
                                    icon: Icons.gif_box_outlined,
                                    color: Colors.indigoAccent,
                                    title: "Gif",
                                    onTap: () {},
                                  ),
                                  attachWindowItem(
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

  Future<void> sendTextMessage() async {
    await sendMessage(
      message: _textMessageController.text,
      type: MessageTypeConst.textMessage,
    );
  }

  Future<void> sendImageMessage() async {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: file!,
      onComplete: (isUploading) {},
      uid: widget.messageEntity.senderUid,
      otherUid: widget.messageEntity.recipientUid,
      type: MessageTypeConst.photoMessage,
    ).then((photoUrl) async {
      await sendMessage(message: photoUrl, type: MessageTypeConst.photoMessage);
    });
  }

  Future<void> sendVideoMessage() async {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: video!,
      onComplete: (isUploading) {},
      uid: widget.messageEntity.senderUid,
      otherUid: widget.messageEntity.recipientUid,
      type: MessageTypeConst.videoMessage,
    ).then((videoUrl) async {
      await sendMessage(message: videoUrl, type: MessageTypeConst.videoMessage);
    });
  }

  Future<void> sendGifMessage() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      String fixedUrl = "https://media.giphy.com/media/${gif.id}/giphy.gif";
      await sendMessage(message: fixedUrl, type: MessageTypeConst.gifMessage);
    }
  }

  Future<void> sendMessage({
    required String? message,
    required String type,
    String? repliedMessage,
    String? repliedTo,
    String? repliedMessageType,
  }) async {
    await ChatUtils.sendMessage(
      context: context,
      messageEntity: widget.messageEntity,
      message: message,
      type: type,
      repliedMessage: repliedMessage,
      repliedTo: repliedTo,
      repliedMessageType: repliedMessageType,
    ).then((value) {
      setState(() {
        _textMessageController.clear();
      });
    });
  }
}
