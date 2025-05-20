import 'package:flutter/material.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/features/call/presentation/pages/call_contact_page.dart';
import 'package:whatsapp/features/home/contact_page.dart';
import 'package:whatsapp/features/settings/settings_page.dart';
import 'package:whatsapp/features/status/presentation/pages/my_status_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final arg = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        return materialPageRoute(const ContactPage());
      case PageConst.settingsPage:
        return materialPageRoute(const SettingsPage());
      case PageConst.myStatusPage:
        return materialPageRoute(const MyStatusPage());
      case PageConst.callContactsPage:
        return materialPageRoute(const CallContactPage());
      default:
    }
    return null;
  }
}

dynamic materialPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
