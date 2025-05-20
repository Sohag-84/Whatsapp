import 'package:flutter/material.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/features/home/contact_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final arg = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        return materialPageRoute(const ContactPage());
      default:
    }
    return null;
  }
}

dynamic materialPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
