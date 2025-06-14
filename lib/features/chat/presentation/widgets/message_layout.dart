import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/core/const/message_type_const.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/chat/domain/entities/message_reply_entity.dart';
import 'package:whatsapp/features/chat/presentation/widgets/message_widgets/message_reply_type_widget.dart';
import 'package:whatsapp/features/chat/presentation/widgets/message_widgets/message_type_widget.dart';

Widget messageLayout({
  required BuildContext context,
  Color? messageBgColor,
  Alignment? alignment,
  Timestamp? createAt,
  VoidCallback? onSwipe,
  String? message,
  required String messageType,
  bool? isShowTick,
  bool? isSeen,
  VoidCallback? onLongPress,
  MessageReplayEntity? reply,
  required String recipientName,
  double? rightPadding,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: SwipeTo(
      onRightSwipe: (value) => onSwipe?.call(),
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
                    padding: EdgeInsets.only(
                      left: 5,
                      right:
                          messageType == MessageTypeConst.textMessage
                              ? rightPadding!
                              : 5,
                      top: 5,
                      bottom: 5,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                    ),
                    decoration: BoxDecoration(
                      color: messageBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reply?.message == null || reply?.message == ""
                            ? const SizedBox()
                            : Container(
                              height:
                                  reply!.messageType ==
                                          MessageTypeConst.textMessage
                                      ? 70
                                      : 80,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: 4.5,
                                    decoration: BoxDecoration(
                                      color:
                                          reply.username == recipientName
                                              ? Colors.deepPurpleAccent
                                              : tabColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${reply.username == recipientName ? reply.username : "You"}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  reply.username ==
                                                          recipientName
                                                      ? Colors.deepPurpleAccent
                                                      : tabColor,
                                            ),
                                          ),
                                          MessageReplayTypeWidget(
                                            message: reply.message,
                                            type: reply.messageType,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        const SizedBox(height: 3),

                        MessageTypeWidget(message: message, type: messageType),
                      ],
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
