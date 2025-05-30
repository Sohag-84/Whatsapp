// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/core/const/app_const.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:whatsapp/storage/storage_provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();

  File? image;
  bool isProfileUpdating = false;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );

      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.user.username);
    _aboutController = TextEditingController(text: widget.user.status);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: profileWidget(
                        imageUrl: widget.user.profileUrl,
                        image: image,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: tabColor,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: blackColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _profileItem(
              controller: _usernameController,
              title: "Name",
              description: "Enter username",
              icon: Icons.person,
              onTap: () {},
            ),
            _profileItem(
              controller: _aboutController,
              title: "About",
              description: "Hey there I'm using WhatsApp",
              icon: Icons.info_outline,
              onTap: () {},
            ),
            _settingsItemWidget(
              title: "Phone",
              description: "${widget.user.phoneNumber}",
              icon: Icons.phone,
              onTap: () {},
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: submitProfileInfo,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child:
                    isProfileUpdating == true
                        ? const Center(
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(color: whiteColor),
                          ),
                        )
                        : const Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _profileItem({
    String? title,
    String? description,
    IconData? icon,
    VoidCallback? onTap,
    TextEditingController? controller,
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
                Text(
                  "$title",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: description!,
                      suffixIcon: const Icon(
                        Icons.edit_rounded,
                        color: tabColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                Text(
                  "$title",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 3),
                Text("$description", style: const TextStyle(fontSize: 17)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitProfileInfo() async {
    if (image != null) {
      StorageProviderRemoteDataSource.uploadProfileImage(
        file: image!,
        onComplete: (onProfileUpdateComplete) {
          setState(() {
            isProfileUpdating = onProfileUpdateComplete;
          });
        },
      ).then((profileImageUrl) {
        profileInfo(profileUrl: profileImageUrl);
      });
    } else {
      profileInfo(profileUrl: widget.user.profileUrl);
    }
  }

  void profileInfo({String? profileUrl}) {
    if (_usernameController.text.isNotEmpty) {
      context
          .read<UserCubit>()
          .updateUser(
            userEntity: UserEntity(
              uid: widget.user.uid,
              email: widget.user.email,
              username: _usernameController.text,
              phoneNumber: widget.user.phoneNumber,
              status: _aboutController.text,
              isOnline: false,
              profileUrl: profileUrl,
            ),
          )
          .then((value) {
            toast("Profile updated");
          });
    }
  }
}
