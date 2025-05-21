import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/signin_with_phone_number_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/verify_phone_number_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/user/create_user_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SigninWithPhoneNumberUsecase signinWithPhoneNumberUsecase;
  final VerifyPhoneNumberUsecase verifyPhoneNumberUsecase;
  final CreateUserUsecase createUserUsecase;
  CredentialCubit({
    required this.signinWithPhoneNumberUsecase,
    required this.verifyPhoneNumberUsecase,
    required this.createUserUsecase,
  }) : super(CredentialInitial());

  Future<void> submitVerifyPhoneNumber({required String phoneNumber}) async {
    try {
      await verifyPhoneNumberUsecase.call(phoneNumber: phoneNumber);
      emit(CredentialPhoneAuthSmsCodeReceived());
    } on SocketException catch (e) {
      emit(CredentialFailure(error: e.message));
    } catch (e) {
      emit(CredentialFailure(error: e.toString()));
    }
  }

  Future<void> submitSmsCode({required String smsCode}) async {
    try {
      await signinWithPhoneNumberUsecase.call(smsPinCode: smsCode);
      emit(CredentialPhoneAuthProfileInfo());
    } on SocketException catch (e) {
      emit(CredentialFailure(error: e.message));
    } catch (e) {
      emit(CredentialFailure(error: e.toString()));
    }
  }

  Future<void> submitProfileInfo({required UserEntity user}) async {
    try {
      await createUserUsecase.call(userEntity: user);
      emit(CredentialSuccess());
    } on SocketException catch (e) {
      emit(CredentialFailure(error: e.message));
    } catch (e) {
      emit(CredentialFailure(error: e.toString()));
    }
  }
}
