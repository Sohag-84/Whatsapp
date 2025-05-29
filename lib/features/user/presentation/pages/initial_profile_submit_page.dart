import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/core/const/app_const.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:whatsapp/storage/storage_provider.dart';

class InitialProfileSubmitPage extends StatefulWidget {
  final String email;
  const InitialProfileSubmitPage({super.key, required this.email});

  @override
  State<InitialProfileSubmitPage> createState() =>
      _InitialProfileSubmitPageState();
}

class _InitialProfileSubmitPageState extends State<InitialProfileSubmitPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  static Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode("880");
  String countryCode = _selectedFilteredDialogCountry.phoneCode;

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  File? _image;

  bool isProfileUpdating = false;

  Future selectImage() async {
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Profile Info",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: tabColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please provide your name, number and an optional profile photo",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 30),

              ///select profile image
              GestureDetector(
                onTap: selectImage,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: profileWidget(image: _image),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              ///username
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 1.5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: tabColor, width: 1.5),
                  ),
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: "Username",
                    border: InputBorder.none,
                  ),
                ),
              ),

              ///phone number
              const SizedBox(height: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                onTap: _openFilteredCountryPickerDialog,
                title: _buildDialogItem(_selectedFilteredDialogCountry),
              ),
              Row(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.50, color: tabColor),
                      ),
                    ),
                    width: 80,
                    height: 42,
                    alignment: Alignment.center,
                    child: Text(_selectedFilteredDialogCountry.phoneCode),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 1.5),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: tabColor, width: 1.5),
                        ),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          hintText: "Enter number without country code",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///submit button
              const SizedBox(height: 20),
              GestureDetector(
                onTap: submitProfileInfo,
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tabColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "Next",
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
      ),
    );
  }

  void _openFilteredCountryPickerDialog() {
    showDialog(
      context: context,
      builder:
          (_) => Theme(
            data: Theme.of(context).copyWith(primaryColor: tabColor),
            child: CountryPickerDialog(
              titlePadding: const EdgeInsets.all(8.0),
              searchCursorColor: tabColor,
              searchInputDecoration: const InputDecoration(hintText: "Search"),
              isSearchable: true,
              title: const Text("Select your phone code"),
              onValuePicked: (Country country) {
                setState(() {
                  _selectedFilteredDialogCountry = country;
                  countryCode = country.phoneCode;
                });
              },
              itemBuilder: _buildDialogItem,
            ),
          ),
    );
  }

  Widget _buildDialogItem(Country country) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: tabColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Text(" +${country.phoneCode}"),
          Expanded(
            child: Text(
              " ${country.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void submitProfileInfo() {
    if (_image != null) {
      StorageProviderRemoteDataSource.uploadProfileImage(
        file: _image!,
        onComplete: (onProfileUpdateComplete) {
          setState(() {
            isProfileUpdating = onProfileUpdateComplete;
          });
        },
      ).then((profileImageUrl) {
        _profileInfo(profileUrl: profileImageUrl);
      });
    } else {
      _profileInfo(profileUrl: "");
    }
  }

  void _profileInfo({String? profileUrl}) {
    if (_usernameController.text.trim().isEmpty) {
      toast("Username can't be empty");
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      toast("Phone number can't be empty");
      return;
    }

    context.read<CredentialCubit>().submitProfileInfo(
      user: UserEntity(
        email: widget.email,
        username: _usernameController.text,
        phoneNumber: "+$countryCode${_phoneController.text.trim()}",
        status: "Hey There! I'm using WhatsApp Clone",
        isOnline: false,
        profileUrl: profileUrl,
      ),
    );
  }
}
