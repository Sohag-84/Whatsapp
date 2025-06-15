import 'package:whatsapp/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:whatsapp/features/chat/data/data_source/chat_remote_data_source_impl.dart';
import 'package:whatsapp/features/chat/data/repository/chat_repository_impl.dart';
import 'package:whatsapp/features/chat/domain/repository/chat_repository.dart';
import 'package:whatsapp/features/chat/domain/usecases/delete_message_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/delete_my_chat_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/get_message_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/get_my_chat_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/seen_message_update_usecase.dart';
import 'package:whatsapp/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:whatsapp/features/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:whatsapp/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:whatsapp/main_injection_container.dart';

Future<void> chatInjectionContainer() async {
  /// CUBIT INJECTION
  sl.registerFactory<ChatCubit>(
    () =>
        ChatCubit(getMyChatUsecase: sl.call(), deleteMyChatUsecase: sl.call()),
  );
  sl.registerFactory<MessageCubit>(
    () => MessageCubit(
      getMessageUsecase: sl.call(),
      deleteMessageUsecase: sl.call(),
      sendMessageUsecase: sl.call(),
      seenMessageUpdateUsecase: sl.call(),
    ),
  );

  ///USE CASE INJECTION
  sl.registerLazySingleton<DeleteMessageUsecase>(
    () => DeleteMessageUsecase(chatRepository: sl.call()),
  );
  sl.registerLazySingleton<DeleteMyChatUsecase>(
    () => DeleteMyChatUsecase(chatRepository: sl.call()),
  );
  sl.registerLazySingleton<GetMessageUsecase>(
    () => GetMessageUsecase(chatRepository: sl.call()),
  );
  sl.registerLazySingleton<GetMyChatUsecase>(
    () => GetMyChatUsecase(chatRepository: sl.call()),
  );
  sl.registerLazySingleton<SendMessageUsecase>(
    () => SendMessageUsecase(sl.call()),
  );
  sl.registerLazySingleton<SeenMessageUpdateUsecase>(
    () => SeenMessageUpdateUsecase(chatRepository: sl.call()),
  );

  ///REPOSITORY & DATA SOURCE INJECTION
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(chatRemoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(firestore: sl.call()),
  );
}
