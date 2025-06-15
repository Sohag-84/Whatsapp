// ignore_for_file: invalid_use_of_visible_for_testing_member, use_build_context_synchronously

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/core/const/app_const.dart';
import 'package:whatsapp/core/const/message_type_const.dart';
import 'package:whatsapp/core/global/widgets/dialog_widget.dart';
import 'package:whatsapp/core/global/widgets/loader.dart';
import 'package:whatsapp/core/global/widgets/show_image_picked_widget.dart';
import 'package:whatsapp/core/global/widgets/show_video_picked_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chat/domain/entities/message_reply_entity.dart';
import 'package:whatsapp/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:whatsapp/features/chat/presentation/widgets/attach_window_item.dart';
import 'package:whatsapp/features/chat/presentation/widgets/chat_utils.dart';
import 'package:whatsapp/features/chat/presentation/widgets/message_layout.dart';
import 'package:whatsapp/features/chat/presentation/widgets/message_widgets/message_reply_preview_widget.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:whatsapp/storage/storage_provider.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity messageEntity;
  const SingleChatPage({super.key, required this.messageEntity});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isDisplaySendButton = false;
  bool isShowAttachWindow = false;

  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;
  bool _isRecordInit = false;

  File? image;
  File? video;

  bool isShowEmojiKeyboard = false;
  FocusNode focusNode = FocusNode();

  void _hideEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = false;
    });
  }

  void _showEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = true;
    });
  }

  void _showKeyboard() => focusNode.requestFocus();
  void _hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiKeyboard) {
      _showKeyboard();
      _hideEmojiContainer();
    } else {
      _hideKeyboard();
      _showEmojiContainer();
    }
  }

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

  Future<void> _openAudioRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    _isRecordInit = true;
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void onMessageSwipe({
    String? message,
    String? username,
    String? type,
    bool? isMe,
  }) {
    context.read<MessageCubit>().setMessageReplay = MessageReplayEntity(
      message: message,
      username: username,
      messageType: type,
      isMe: isMe,
    );
  }

  @override
  void initState() {
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();
    context.read<GetSingleUserCubit>().getSingleUser(
      uid: widget.messageEntity.recipientUid!,
    );
    context.read<MessageCubit>().getMessages(
      messageEntity: MessageEntity(
        senderUid: widget.messageEntity.senderUid,
        recipientUid: widget.messageEntity.recipientUid,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    final provider = context.read<MessageCubit>();
    bool isReplying = provider.messageReplay.message != null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.messageEntity.recipientName ?? ""),
            BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
              builder: (context, state) {
                if (state is GetSingleUserLoaded) {
                  return state.singleUser.isOnline == true
                      ? const Text(
                        "Online",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                      : Container();
                }

                return Container();
              },
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
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
                          controller: _scrollController,
                          itemCount: state.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final message = state.messages[index];
                            if (message.isSeen == false &&
                                message.recipientUid ==
                                    widget.messageEntity.uid) {
                              provider.seenMessage(
                                messageEntity: MessageEntity(
                                  senderUid: widget.messageEntity.senderUid,
                                  recipientUid:
                                      widget.messageEntity.recipientUid,
                                  messageId: message.messageId,
                                ),
                              );
                            }
                            if (message.senderUid ==
                                widget.messageEntity.senderUid) {
                              return messageLayout(
                                context: context,
                                message: message.message,
                                recipientName:
                                    widget.messageEntity.recipientName ?? "",
                                messageType:
                                    message.messageType ??
                                    MessageTypeConst.textMessage,
                                alignment: Alignment.centerRight,
                                createAt: message.createdAt,
                                isSeen: message.isSeen,
                                isShowTick: true,
                                messageBgColor: messageColor,
                                rightPadding:
                                    message.repliedMessage == "" ? 85 : 5,
                                reply: MessageReplayEntity(
                                  message: message.repliedMessage,
                                  messageType: message.repliedMessageType,
                                  username: message.repliedTo,
                                ),
                                onLongPress: () {
                                  focusNode.unfocus();
                                  displayAlertDialog(
                                    context,
                                    onTap: () {
                                      context
                                          .read<MessageCubit>()
                                          .deleteMessage(
                                            messageEntity: MessageEntity(
                                              senderUid:
                                                  widget
                                                      .messageEntity
                                                      .senderUid,
                                              recipientUid:
                                                  widget
                                                      .messageEntity
                                                      .recipientUid,
                                              messageId: message.messageId,
                                            ),
                                          );
                                      Navigator.pop(context);
                                    },
                                    confirmTitle: "Delete",
                                    content:
                                        "Are you sure you want to delete this message?",
                                  );
                                },
                                onSwipe: () {
                                  onMessageSwipe(
                                    message: message.message,
                                    username: message.senderName,
                                    type: message.messageType,
                                    isMe: true,
                                  );

                                  setState(() {});
                                },
                              );
                            } else {
                              return messageLayout(
                                context: context,
                                message: message.message,
                                recipientName:
                                    widget.messageEntity.recipientName ?? "",
                                messageType:
                                    message.messageType ??
                                    MessageTypeConst.textMessage,
                                alignment: Alignment.centerLeft,
                                createAt: message.createdAt,
                                isSeen: message.isSeen,
                                isShowTick: false,
                                messageBgColor: senderMessageColor,
                                rightPadding:
                                    message.repliedMessage == "" ? 85 : 5,
                                reply: MessageReplayEntity(
                                  message: message.repliedMessage,
                                  messageType: message.repliedMessageType,
                                  username: message.repliedTo,
                                ),
                                onLongPress: () {
                                  focusNode.unfocus();
                                  displayAlertDialog(
                                    context,
                                    onTap: () {
                                      context
                                          .read<MessageCubit>()
                                          .deleteMessage(
                                            messageEntity: MessageEntity(
                                              senderUid:
                                                  widget
                                                      .messageEntity
                                                      .senderUid,
                                              recipientUid:
                                                  widget
                                                      .messageEntity
                                                      .recipientUid,
                                              messageId: message.messageId,
                                            ),
                                          );
                                      Navigator.pop(context);
                                    },
                                    confirmTitle: "Delete",
                                    content:
                                        "Are you sure you want to delete this message?",
                                  );
                                },
                                onSwipe: () {
                                  onMessageSwipe(
                                    message: message.message,
                                    username: message.senderName,
                                    type: message.messageType,
                                    isMe: false,
                                  );

                                  setState(() {});
                                },
                              );
                            }
                          },
                        ),
                      ),

                      isReplying == true
                          ? const SizedBox(height: 5)
                          : const SizedBox(height: 0),

                      isReplying == true
                          ? Row(
                            children: [
                              Expanded(
                                child: MessageReplayPreviewWidget(
                                  onCancelReplayListener: () {
                                    provider.setMessageReplay =
                                        MessageReplayEntity();
                                    setState(() {});
                                  },
                                ),
                              ),
                              Container(width: 60),
                            ],
                          )
                          : const SizedBox(),

                      ///message type field
                      Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: isReplying == true ? 0 : 5,
                          bottom: 5,
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
                                  borderRadius:
                                      isReplying == true
                                          ? const BorderRadius.only(
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                          )
                                          : BorderRadius.circular(25),
                                ),
                                child: TextField(
                                  controller: _textMessageController,
                                  focusNode: focusNode,
                                  onTap: () {
                                    setState(() {
                                      isShowAttachWindow = false;
                                      isShowEmojiKeyboard = false;
                                    });
                                  },

                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        _textMessageController.text = value;
                                        isDisplaySendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        _textMessageController.text = value;
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
                                    prefixIcon: GestureDetector(
                                      onTap: toggleEmojiKeyboard,
                                      child: Icon(
                                        isShowEmojiKeyboard == false
                                            ? Icons.emoji_emotions
                                            : Icons.keyboard_outlined,
                                        color: greyColor,
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Wrap(
                                        children: [
                                          ///send video message
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

                                          ///send image message
                                          GestureDetector(
                                            onTap: () {
                                              selectImage().then((value) {
                                                if (image != null) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        timeStamp,
                                                      ) {
                                                        showImagePickedBottomModalSheet(
                                                          context,
                                                          recipientName:
                                                              widget
                                                                  .messageEntity
                                                                  .recipientName,
                                                          file: image,
                                                          onTap: () async {
                                                            await sendImageMessage();
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                        );
                                                      });
                                                }
                                              });
                                            },
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: greyColor,
                                            ),
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
                              onTap: () async {
                                await sendTextMessage();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: tabColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Icon(
                                    isDisplaySendButton ||
                                            _textMessageController
                                                .text
                                                .isNotEmpty
                                        ? Icons.send_outlined
                                        : _isRecording
                                        ? Icons.close
                                        : Icons.mic,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///to send emoji message
                      isShowEmojiKeyboard
                          ? SizedBox(
                            height: 310,
                            child: Stack(
                              children: [
                                EmojiPicker(
                                  onEmojiSelected: ((category, emoji) {
                                    setState(() {
                                      _textMessageController.text =
                                          _textMessageController.text +
                                          emoji.emoji;
                                    });
                                  }),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: appBarColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.search,
                                            size: 20,
                                            color: greyColor,
                                          ),
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.emoji_emotions_outlined,
                                                size: 20,
                                                color: tabColor,
                                              ),
                                              SizedBox(width: 15),
                                              Icon(
                                                Icons.gif_box_outlined,
                                                size: 20,
                                                color: greyColor,
                                              ),
                                              SizedBox(width: 15),
                                              Icon(
                                                Icons.ad_units,
                                                size: 20,
                                                color: greyColor,
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _textMessageController.text =
                                                    _textMessageController.text
                                                        .substring(
                                                          0,
                                                          _textMessageController
                                                                  .text
                                                                  .length -
                                                              2,
                                                        );
                                              });
                                            },
                                            child: const Icon(
                                              Icons.backspace_outlined,
                                              size: 20,
                                              color: greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : const SizedBox(),
                    ],
                  ),

                  ///attach file window
                  isShowAttachWindow == true
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

                                  ///to send image message
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
                                    onTap: () {
                                      selectImage().then((value) {
                                        if (image != null) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((
                                                timeStamp,
                                              ) {
                                                showImagePickedBottomModalSheet(
                                                  context,
                                                  recipientName:
                                                      widget
                                                          .messageEntity
                                                          .recipientName,
                                                  file: image,
                                                  onTap: () async {
                                                    await sendImageMessage();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              });
                                        }
                                      });
                                    },
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
                                  //to send Gif message
                                  attachWindowItem(
                                    icon: Icons.gif_box_outlined,
                                    color: Colors.indigoAccent,
                                    title: "Gif",
                                    onTap: () async {
                                      await sendGifMessage();
                                      setState(() {
                                        isShowAttachWindow = false;
                                      });
                                    },
                                  ),

                                  ///to send video message
                                  attachWindowItem(
                                    icon: Icons.videocam_rounded,
                                    color: Colors.lightGreen,
                                    title: "Video",
                                    onTap: () {
                                      selectVideo().then((value) {
                                        if (video != null) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((
                                                timeStamp,
                                              ) {
                                                showVideoPickedBottomModalSheet(
                                                  context,
                                                  recipientName:
                                                      widget
                                                          .messageEntity
                                                          .recipientName,
                                                  file: video,
                                                  onTap: () async {
                                                    await sendVideoMessage();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              });
                                        }
                                      });
                                      setState(() {
                                        isShowAttachWindow = false;
                                      });
                                    },
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
    final provider = context.read<MessageCubit>();
    if (isDisplaySendButton || _textMessageController.text.isNotEmpty) {
      if (provider.messageReplay.message != null) {
        sendMessage(
          message: _textMessageController.text,
          type: MessageTypeConst.textMessage,
          repliedMessage: provider.messageReplay.message,
          repliedTo: provider.messageReplay.username,
          repliedMessageType: provider.messageReplay.messageType,
        );
      } else {
        await sendMessage(
          message: _textMessageController.text,
          type: MessageTypeConst.textMessage,
        );
      }
      provider.setMessageReplay = MessageReplayEntity();
      setState(() {
        _textMessageController.clear();
      });
    } else {
      final temporaryDir = await getTemporaryDirectory();
      final audioPath = '${temporaryDir.path}/flutter_sound.aac';
      if (!_isRecordInit) {
        return;
      }
      if (_isRecording == true) {
        await _soundRecorder!.stopRecorder();
        StorageProviderRemoteDataSource.uploadMessageFile(
          file: File(audioPath),
          onComplete: (value) {},
          uid: widget.messageEntity.senderUid,
          otherUid: widget.messageEntity.recipientUid,
          type: MessageTypeConst.audioMessage,
        ).then((audioUrl) {
          sendMessage(message: audioUrl, type: MessageTypeConst.audioMessage);
        });
      } else {
        await _soundRecorder!.startRecorder(toFile: audioPath);
      }

      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }

  Future<void> sendImageMessage() async {
    await StorageProviderRemoteDataSource.uploadMessageFile(
      file: image!,
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
    _scrollToBottom();
    await ChatUtils.sendMessage(
      context: context,
      messageEntity: widget.messageEntity,
      message: message,
      type: type,
      repliedMessage: repliedMessage,
      repliedTo: repliedTo,
      repliedMessageType: repliedMessageType,
    ).then((value) {
      _scrollToBottom();
    });
  }
}
