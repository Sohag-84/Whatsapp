import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/splash/splash_screen.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/user/user_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (context) => di.sl<CredentialCubit>()),
        BlocProvider(create: (context) => di.sl<UserCubit>()),
        BlocProvider(create: (context) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (context) => di.sl<GetDeviceNumberCubit>()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
