import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, PageConst.singleChatPage);
            },
            leading: SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: profileWidget(),
              ),
            ),
            title: Text("ihsohag"),
            subtitle: Text(
              "last message hi",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              DateFormat.jm().format(DateTime.now()),
              style: const TextStyle(color: greyColor, fontSize: 13),
            ),
          );
        },
      ),
    );
  }
}
