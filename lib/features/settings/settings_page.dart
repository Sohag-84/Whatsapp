import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

class SettingsPage extends StatefulWidget {
  final String uid;
  const SettingsPage({super.key, required this.uid});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetSingleUserCubit>().getSingleUser(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          ///profile image and username section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
              builder: (context, state) {
                if (state is GetSingleUserLoaded) {
                  final user = state.singleUser;
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.editProfilePage,
                            arguments: user,
                          );
                        },
                        child: SizedBox(
                          height: 65,
                          width: 65,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.5),
                            child: profileWidget(imageUrl: user.profileUrl),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user.username}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${user.status}",
                              style: TextStyle(color: greyColor),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.qr_code_sharp, color: tabColor),
                    ],
                  );
                } else {
                  ///instead of loading, here use emtpy name and status
                  ///for better user performance
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.editProfilePage,
                          );
                        },
                        child: SizedBox(
                          height: 65,
                          width: 65,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.5),
                            child: profileWidget(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("......", style: TextStyle(fontSize: 15)),
                            Text("......", style: TextStyle(color: greyColor)),
                          ],
                        ),
                      ),
                      const Icon(Icons.qr_code_sharp, color: tabColor),
                    ],
                  );
                }
              },
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
