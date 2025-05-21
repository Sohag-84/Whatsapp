part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLoaded extends UserState {
  final List<UserEntity> userList;
  const UserLoaded({required this.userList});

  @override
  List<Object> get props => [userList];
}

final class UserFailure extends UserState {
  final String error;
  const UserFailure({required this.error});

  @override
  List<Object> get props => [error];
}
