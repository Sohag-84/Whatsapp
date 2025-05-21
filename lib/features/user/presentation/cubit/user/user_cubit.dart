import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/domain/usecases/user/get_all_user_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUsecase updateUserUsecase;
  final GetAllUserUsecase getAllUserUsecase;

  UserCubit({required this.updateUserUsecase, required this.getAllUserUsecase})
    : super(UserInitial());

  Future<void> getAllUser() async {
    emit(UserLoading());
    final streamResponse = getAllUserUsecase.call();
    streamResponse.listen((users) {
      emit(UserLoaded(userList: users));
    });
  }

  Future<void> updateUser({required UserEntity userEntity}) async {
    try {
      await updateUserUsecase.call(userEntity: userEntity);
    } catch (e) {
      emit(UserFailure(error: e.toString()));
    }
  }
}
