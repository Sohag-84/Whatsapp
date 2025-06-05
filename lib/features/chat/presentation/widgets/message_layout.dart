import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/core/theme/style.dart';

Widget messageLayout({
  required BuildContext context,
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
