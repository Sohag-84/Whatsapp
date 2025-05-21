part of 'credential_cubit.dart';

sealed class CredentialState extends Equatable {
  const CredentialState();

  @override
  List<Object> get props => [];
}

class CredentialInitial extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialLoading extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialSuccess extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialPhoneAuthSmsCodeReceived extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialPhoneAuthProfileInfo extends CredentialState {
  @override
  List<Object> get props => [];
}

class CredentialFailure extends CredentialState {
  final String error;
  const CredentialFailure({required this.error});
  @override
  List<Object> get props => [error];
}
