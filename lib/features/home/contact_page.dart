import 'package:flutter/material.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
          );
        },
      ),
    );
  }
}
