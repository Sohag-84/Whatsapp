import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/features/user/domain/entities/contact_entity.dart';
import 'package:whatsapp/features/user/domain/usecases/user/get_device_number_usecase.dart';

part 'get_device_number_state.dart';

class GetDeviceNumberCubit extends Cubit<GetDeviceNumberState> {
  final GetDeviceNumberUsecase getDeviceNumberUsecase;
  GetDeviceNumberCubit({required this.getDeviceNumberUsecase})
    : super(GetDeviceNumberInitial());

  Future<void> getDeviceNumber() async {
    try {
      final contactNumberList = await getDeviceNumberUsecase.call();
      emit(GetDeviceNumberLoaded(contactList: contactNumberList));
    } catch (e) {
      emit(GetDeviceNumberFailure(error: e.toString()));
    }
  }
}
