import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/is_signin_usecase.dart';
import 'package:whatsapp/features/user/domain/usecases/credential/signout_usecase.dart';

part "auth_state.dart";

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUidUsecase getCurrentUidUseCase;
  final IsSigninUsecase isSignInUseCase;
  final SignoutUsecase signOutUseCase;

  AuthCubit({
    required this.getCurrentUidUseCase,
    required this.isSignInUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      bool isSignIn = await isSignInUseCase.call();
      if (isSignIn) {
        final uid = await getCurrentUidUseCase.call();
        emit(Authenticated(uid: uid));
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUseCase.call();
      emit(Authenticated(uid: uid));
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}
