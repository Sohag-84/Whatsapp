import 'package:flutter/material.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.5),
                    child: profileWidget(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Raiyan", style: TextStyle(fontSize: 15)),
                      Text("online", style: TextStyle(color: greyColor)),
                    ],
                  ),
                ),
                const Icon(Icons.qr_code_sharp, color: tabColor),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: double.infinity,
            height: 0.5,
            color: greyColor.withValues(alpha: .4),
          ),
          const SizedBox(height: 10),

          _settingsItemWidget(
            title: "Account",
            description: "Security applications, change number",
            icon: Icons.key,
            onTap: () {},
          ),
          _settingsItemWidget(
            title: "Privacy",
            description: "Block contacts, disappearing messages",
            icon: Icons.lock,
            onTap: () {},
          ),
          _settingsItemWidget(
            title: "Chats",
            description: "Theme, wallpapers, chat history",
            icon: Icons.message,
            onTap: () {},
          ),
          _settingsItemWidget(
            title: "Logout",
            description: "Logout from WhatsApp",
            icon: Icons.exit_to_app,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  _settingsItemWidget({
    String? title,
    String? description,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Icon(icon, color: greyColor, size: 25),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$title", style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 3),
                Text("$description", style: const TextStyle(color: greyColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
