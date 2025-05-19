import 'package:flutter/material.dart';
import 'package:whatsapp/core/global/date/date_formats.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({super.key});

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Recent",
                style: TextStyle(
                  fontSize: 15,
                  color: greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 15),

            ///call history list
            ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Container(
                    margin: const EdgeInsets.all(3),
                    height: 55,
                    width: 55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: profileWidget(),
                    ),
                  ),
                  title: Text("ihsohag", style: TextStyle(fontSize: 16)),
                  subtitle: Row(
                    children: [
                      const Icon(
                        Icons.call_made,
                        color: Colors.green,
                        size: 19,
                      ),
                      SizedBox(width: 10),
                      Text(formatDateTime(DateTime.now())),
                    ],
                  ),
                  trailing: const Icon(Icons.call, color: tabColor),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
