import 'package:flutter/material.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';

class CallContactPage extends StatefulWidget {
  const CallContactPage({super.key});

  @override
  State<CallContactPage> createState() => _CallContactPageState();
}

class _CallContactPageState extends State<CallContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Contacts")),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: profileWidget(),
              ),
            ),
            title: Text("Raiyan"),
            subtitle: Text("Hey there, I'm using WhatsApp"),
            trailing: Wrap(
              children: [
                Icon(Icons.call, color: tabColor, size: 22),
                SizedBox(width: 12),
                Icon(Icons.videocam_rounded, color: tabColor, size: 25),
              ],
            ),
          );
        },
      ),
    );
  }
}
