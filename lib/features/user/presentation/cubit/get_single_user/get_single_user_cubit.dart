import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/domain/usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUsecase getSingleUserUsecase;
  GetSingleUserCubit({required this.getSingleUserUsecase})
    : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    try {
      emit(GetSingleUserLoading());
      final streamResponse = getSingleUserUsecase.call(uid: uid);
      streamResponse.listen((users) {
        emit(GetSingleUserLoaded(singleUser: users.first));
      });
    } catch (e) {
      emit(GetSingleUserFailure(error: e.toString()));
    }
  }
}
