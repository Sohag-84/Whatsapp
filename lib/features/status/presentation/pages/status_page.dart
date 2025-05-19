import 'package:flutter/material.dart';
import 'package:whatsapp/core/global/date/date_formats.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///status add section
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: profileWidget(),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 8,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: tabColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(width: 2, color: backgroundColor),
                        ),
                        child: Icon(Icons.add, size: 20),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("My status", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Tap to add your status update",
                          style: TextStyle(color: greyColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ///recent updates
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Recent updates",
                style: TextStyle(
                  fontSize: 15,
                  color: greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 10),
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
                  subtitle: Text(formatDateTime(DateTime.now())),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
