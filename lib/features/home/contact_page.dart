import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/user/presentation/cubit/user/user_cubit.dart';

class ContactPage extends StatefulWidget {
  final String currentUserUid;
  const ContactPage({super.key, required this.currentUserUid});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Contacts")),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            final users =
                state.userList
                    .where((user) => user.uid != widget.currentUserUid)
                    .toList();
            if (users.isEmpty) {
              return Center(
                child: Text("No Contacts Yet", style: TextStyle(fontSize: 16)),
              );
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: profileWidget(imageUrl: user.profileUrl),
                    ),
                  ),
                  title: Text("${user.username}"),
                  subtitle: Text("${user.status}"),
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
