import 'package:flutter/material.dart';
import 'package:whatsapp/features/splash/splash_screen.dart';
import 'package:whatsapp/core/theme/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        dialogTheme: DialogTheme(backgroundColor: appBarColor),
        appBarTheme: AppBarTheme(color: appBarColor),
      ),
      home: const SplashScreen(),
    );
  }
}
