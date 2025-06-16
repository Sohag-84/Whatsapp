// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/usecases/get_my_status_usecase.dart';

part 'get_my_status_state.dart';

class GetMyStatusCubit extends Cubit<GetMyStatusState> {
  final GetMyStatusUsecase getMyStatusUsecase;
  GetMyStatusCubit({required this.getMyStatusUsecase})
    : super(GetMyStatusInitial());

  Future<void> getMyStatus({required String uid}) async {
    try {
      emit(GetMyStatusLoading());
      final streamResponse = getMyStatusUsecase.call(uid: uid);
      streamResponse.listen((statuses) {
        print("Mystatuses = $statuses");
        if (statuses.isEmpty) {
          emit(const GetMyStatusLoaded(myStatus: null));
        } else {
          emit(GetMyStatusLoaded(myStatus: statuses.first));
        }
      });
    } on SocketException {
      emit(GetMyStatusFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(GetMyStatusFailure(error: e.toString()));
    }
  }
}
