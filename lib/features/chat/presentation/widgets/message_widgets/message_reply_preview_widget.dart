import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/const/message_type_const.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:whatsapp/features/chat/presentation/widgets/message_widgets/message_reply_type_widget.dart';

class MessageReplayPreviewWidget extends StatelessWidget {
  final VoidCallback? onCancelReplayListener;
  const MessageReplayPreviewWidget({super.key, this.onCancelReplayListener});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MessageCubit>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height:
          provider.messageReplay.messageType == MessageTypeConst.textMessage
              ? 70
              : 100,
      decoration: const BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor.withValues(alpha: .4),
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 3.5,
              decoration: BoxDecoration(
                color:
                    provider.messageReplay.isMe == true
                        ? tabColor
                        : Colors.deepPurpleAccent,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${provider.messageReplay.isMe == true ? "You" : provider.messageReplay.username}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  provider.messageReplay.isMe == true
                                      ? tabColor
                                      : Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onCancelReplayListener,
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    provider.messageReplay.messageType ==
                            MessageTypeConst.textMessage
                        ? Text(
                          "${provider.messageReplay.message}",
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                        : Row(
                          children: [
                            MessageReplayTypeWidget(
                              message: provider.messageReplay.message,
                              type: provider.messageReplay.messageType,
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
