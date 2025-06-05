import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/core/global/widgets/loader.dart';
import 'package:whatsapp/core/global/widgets/profile_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/chat/domain/entities/message_entity.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
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
    context.read<UserCubit>().getAllUser();
    context.read<GetSingleUserCubit>().getSingleUser(
      uid: widget.currentUserUid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Contacts")),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
          if (state is GetSingleUserLoading) {
            return loader();
          }
          if (state is GetSingleUserLoaded) {
            final currentUser = state.singleUser;
            return BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  final users =
                      state.userList
                          .where((user) => user.uid != widget.currentUserUid)
                          .toList();
                  if (users.isEmpty) {
                    return Center(
                      child: Text(
                        "No Contacts Yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = users[index];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.singleChatPage,
                            arguments: MessageEntity(
                              senderUid: currentUser.uid,
                              recipientUid: user.uid,
                              senderName: currentUser.username,
                              recipientName: user.username,
                              senderProfile: currentUser.profileUrl,
                              recipientProfile: user.profileUrl,
                              uid: widget.currentUserUid,
                            ),
                          );
                        },
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
