import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp/features/chat/chat_injection_container.dart';
import 'package:whatsapp/features/status/status_injection_container.dart';
import 'package:whatsapp/features/user/user_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firestore);

  await userInjectionContainer();
  await chatInjectionContainer();
  await statusInjectionContainer();
}
