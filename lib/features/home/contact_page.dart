import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetDeviceNumberCubit>().getDeviceNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Contacts")),
      body: BlocBuilder<GetDeviceNumberCubit, GetDeviceNumberState>(
        builder: (context, state) {
          if (state is GetDeviceNumberLoaded) {
            return ListView.builder(
              itemCount: state.contactList.length,
              itemBuilder: (BuildContext context, int index) {
                final contact = state.contactList[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.memory(
                        contact.photo ?? Uint8List(0),
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset("assets/profile_default.png");
                        },
                      ),
                      //child: profileWidget(),
                    ),
                  ),
                  title: Text(
                    "${contact.name?.first ?? ""} ${contact.name?.last ?? ""}",
                  ),
                  subtitle: Text("Hey there, I'm using WhatsApp"),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: tabColor),
            );
          }
        },
      ),
    );
  }
}
