import 'package:flutter/material.dart';
import 'package:whatsapp/features/splash/splash_screen.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/routes/on_generate_route.dart';
import 'main_injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
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
        appBarTheme: AppBarTheme(color: appBarColor, centerTitle: true),
      ),
      initialRoute: "/",
      onGenerateRoute: OnGenerateRoute.route,
      routes: {"/": (context) => SplashScreen()},
    );
  }
}
