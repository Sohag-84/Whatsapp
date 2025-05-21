import 'package:whatsapp/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:whatsapp/features/user/data/data_sources/user_remote_data_source_impl.dart';
import 'package:whatsapp/features/user/data/repository/user_repository_impl.dart';
import 'package:whatsapp/features/user/domain/repository/user_repository.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/is_signin_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/signin_with_phone_number_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/signout_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/verify_phone_number_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/user/create_user_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/user/get_all_user_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/user/get_device_number_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/user/get_single_user_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/user/update_user_usecase.dart';
import 'package:whatsapp/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:whatsapp/main_injection_container.dart';

Future<void> userInjectionContainer() async {
  ///CUBIT INJECTION
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      getCurrentUidUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
    ),
  );

  sl.registerFactory<UserCubit>(
    () => UserCubit(updateUserUsecase: sl.call(), getAllUserUsecase: sl.call()),
  );
  sl.registerFactory<GetSingleUserCubit>(
    () => GetSingleUserCubit(getSingleUserUsecase: sl.call()),
  );
  sl.registerFactory<CredentialCubit>(
    () => CredentialCubit(
      signinWithPhoneNumberUsecase: sl.call(),
      verifyPhoneNumberUsecase: sl.call(),
      createUserUsecase: sl.call(),
    ),
  );
  sl.registerFactory<GetDeviceNumberCubit>(
    () => GetDeviceNumberCubit(getDeviceNumberUsecase: sl.call()),
  );

  ///USE CASE INJECTION
  sl.registerLazySingleton<GetCurrentUidUsecase>(
    () => GetCurrentUidUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<IsSigninUsecase>(
    () => IsSigninUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<SigninWithPhoneNumberUsecase>(
    () => SigninWithPhoneNumberUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<SignoutUsecase>(
    () => SignoutUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<VerifyPhoneNumberUsecase>(
    () => VerifyPhoneNumberUsecase(userRepository: sl.call()),
  );

  sl.registerLazySingleton<CreateUserUsecase>(
    () => CreateUserUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<GetAllUserUsecase>(
    () => GetAllUserUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<GetDeviceNumberUsecase>(
    () => GetDeviceNumberUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<GetSingleUserUsecase>(
    () => GetSingleUserUsecase(userRepository: sl.call()),
  );
  sl.registerLazySingleton<UpdateUserUsecase>(
    () => UpdateUserUsecase(userRepository: sl.call()),
  );

  ///REPOSITORY & DATA SOURCE INJECTION
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userRemoteDataSource: sl.call()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () =>
        UserRemoteDataSourceImpl(firestore: sl.call(), firebaseAuth: sl.call()),
  );
}
