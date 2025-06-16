// ignore_for_file: avoid_print

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/usecases/create_status_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/delete_status_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/get_statuses_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/seen_status_update_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/update_image_only_status_usecase.dart';
import 'package:whatsapp/features/status/domain/usecases/update_status_usecase.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  final CreateStatusUsecase createStatusUsecase;
  final DeleteStatusUsecase deleteStatusUsecase;
  final UpdateStatusUsecase updateStatusUsecase;
  final GetStatusesUsecase getStatusesUsecase;
  final UpdateImageOnlyStatusUsecase updateImageOnlyStatusUsecase;
  final SeenStatusUpdateUsecase seenStatusUpdateUsecase;
  StatusCubit({
    required this.getStatusesUsecase,
    required this.updateStatusUsecase,
    required this.deleteStatusUsecase,
    required this.createStatusUsecase,
    required this.updateImageOnlyStatusUsecase,
    required this.seenStatusUpdateUsecase,
  }) : super(StatusInitial());

  Future<void> getStatuses({required StatusEntity status}) async {
    try {
      emit(StatusLoading());
      final streamResponse = getStatusesUsecase.call(status: status);
      streamResponse.listen((statuses) {
        print("statuses = $statuses");
        emit(StatusLoaded(statuses: statuses));
      });
    } on SocketException {
      emit(StatusFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(StatusFailure(error: e.toString()));
    }
  }

  Future<void> createStatus({required StatusEntity status}) async {
    try {
      await createStatusUsecase.call(status: status);
    } on SocketException {
      emit(StatusFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(StatusFailure(error: e.toString()));
    }
  }

  Future<void> deleteStatus({required StatusEntity status}) async {
    try {
      await deleteStatusUsecase.call(status: status);
    } on SocketException {
      emit(StatusFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(StatusFailure(error: e.toString()));
    }
  }

  Future<void> updateStatus({required StatusEntity status}) async {
    try {
      await updateStatusUsecase.call(status: status);
    } on SocketException {
      emit(StatusFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(StatusFailure(error: e.toString()));
    }
  }

  Future<void> updateOnlyImageStatus({required StatusEntity status}) async {
    try {
      await updateImageOnlyStatusUsecase.call(status: status);
    } on SocketException {
      emit(StatusFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(StatusFailure(error: e.toString()));
    }
  }

  Future<void> seenStatusUpdate({
    required String statusId,
    required int imageIndex,
    required String userId,
  }) async {
    try {
      await seenStatusUpdateUsecase.call(
        statusId: statusId,
        imageIndex: imageIndex,
        userId: userId,
      );
    } on SocketException {
      emit(StatusFailure(error: "No Internet Connection"));
    } catch (e) {
      emit(StatusFailure(error: e.toString()));
    }
  }
}
