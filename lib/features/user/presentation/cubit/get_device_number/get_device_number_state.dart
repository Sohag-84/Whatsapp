part of 'get_device_number_cubit.dart';

sealed class GetDeviceNumberState extends Equatable {
  const GetDeviceNumberState();

  @override
  List<Object> get props => [];
}

final class GetDeviceNumberInitial extends GetDeviceNumberState {
  @override
  List<Object> get props => [];
}

final class GetDeviceNumberLoading extends GetDeviceNumberState {
  @override
  List<Object> get props => [];
}

final class GetDeviceNumberLoaded extends GetDeviceNumberState {
  final List<ContactEntity> contactList;
  const GetDeviceNumberLoaded({required this.contactList});

  @override
  List<Object> get props => [contactList];
}

final class GetDeviceNumberFailure extends GetDeviceNumberState {
  final String error;
  const GetDeviceNumberFailure({required this.error});

  @override
  List<Object> get props => [error];
}
