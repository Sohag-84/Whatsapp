import 'package:flutter/material.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/features/call/presentation/pages/call_contact_page.dart';
import 'package:whatsapp/features/chat/presentation/pages/single_chat_page.dart';
import 'package:whatsapp/features/home/contact_page.dart';
import 'package:whatsapp/features/settings/settings_page.dart';
import 'package:whatsapp/features/status/presentation/pages/my_status_page.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/presentation/pages/edit_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final arg = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        if (arg is String) {
          return materialPageRoute(ContactPage(currentUserUid: arg));
        } else {
          return materialPageRoute(const ErrorWidget());
        }

      case PageConst.settingsPage:
        if (arg is String) {
          return materialPageRoute(SettingsPage(uid: arg));
        } else {
          return materialPageRoute(const ErrorWidget());
        }
      case PageConst.editProfilePage:
        if (arg is UserEntity) {
          return materialPageRoute(EditProfilePage(user: arg));
        } else {
          return materialPageRoute(const ErrorWidget());
        }
      case PageConst.myStatusPage:
        return materialPageRoute(const MyStatusPage());
      case PageConst.callContactsPage:
        return materialPageRoute(const CallContactPage());
      case PageConst.singleChatPage:
        return materialPageRoute(const SingleChatPage());
      default:
        return materialPageRoute(const ErrorWidget());
    }
  }
}

dynamic materialPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Error")),
      body: Center(child: Text("Error")),
    );
  }
}
