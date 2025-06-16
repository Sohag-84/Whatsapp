import 'package:whatsapp/features/status/data/data_source/status_remote_data_source.dart';
import 'package:whatsapp/features/status/data/data_source/status_remote_data_source_impl.dart';
import 'package:whatsapp/features/status/data/repository/status_repository_impl.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';
import 'package:whatsapp/features/status/domain/usecases/create_status_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/delete_status_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/get_my_status_future_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/get_my_status_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/get_statuses_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/seen_status_update_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/update_image_only_status_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/update_status_usecase.dart';
import 'package:whatsapp/features/status/presentation/cubit/get_my_status/get_my_status_cubit.dart';
import 'package:whatsapp/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:whatsapp/main_injection_container.dart';

Future<void> statusInjectionContainer() async {
  /// CUBIT INJECTION
  sl.registerFactory<StatusCubit>(
    () => StatusCubit(
      getStatusesUsecase: sl.call(),
      updateStatusUsecase: sl.call(),
      deleteStatusUsecase: sl.call(),
      createStatusUsecase: sl.call(),
      updateImageOnlyStatusUsecase: sl.call(),
      seenStatusUpdateUsecase: sl.call(),
    ),
  );
  sl.registerFactory<GetMyStatusCubit>(
    () => GetMyStatusCubit(getMyStatusUsecase: sl.call()),
  );

  ///USE CASE INJECTION
  sl.registerLazySingleton<CreateStatusUsecase>(
    () => CreateStatusUsecase(statusRepository: sl.call()),
  );
  sl.registerLazySingleton<DeleteStatusUsecase>(
    () => DeleteStatusUsecase(statusRepository: sl.call()),
  );
  sl.registerLazySingleton<GetMyStatusUsecase>(
    () => GetMyStatusUsecase(statusRepository: sl.call()),
  );
  sl.registerLazySingleton<GetMyStatusFutureUsecase>(
    () => GetMyStatusFutureUsecase(statusRepository: sl.call()),
  );

  sl.registerLazySingleton<GetStatusesUsecase>(
    () => GetStatusesUsecase(statusRepository: sl.call()),
  );

  sl.registerLazySingleton<SeenStatusUpdateUsecase>(
    () => SeenStatusUpdateUsecase(statusRepository: sl.call()),
  );

  sl.registerLazySingleton<UpdateImageOnlyStatusUsecase>(
    () => UpdateImageOnlyStatusUsecase(statusRepository: sl.call()),
  );

  sl.registerLazySingleton<UpdateStatusUsecase>(
    () => UpdateStatusUsecase(statusRepository: sl.call()),
  );

  ///REPOSITORY & DATA SOURCE INJECTION
  sl.registerLazySingleton<StatusRepository>(
    () => StatusRepositoryImpl(statusRemoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<StatusRemoteDataSource>(
    () => StatusRemoteDataSourceImpl(firestore: sl.call()),
  );
}
