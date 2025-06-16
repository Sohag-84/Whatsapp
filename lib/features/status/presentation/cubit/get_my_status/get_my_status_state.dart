part of 'get_my_status_cubit.dart';

sealed class GetMyStatusState extends Equatable {
  const GetMyStatusState();
  @override
  List<Object?> get props => [];
}

final class GetMyStatusInitial extends GetMyStatusState {
  @override
  List<Object?> get props => [];
}

class GetMyStatusLoading extends GetMyStatusState {
  @override
  List<Object> get props => [];
}

class GetMyStatusLoaded extends GetMyStatusState {
  final StatusEntity? myStatus;
  const GetMyStatusLoaded({required this.myStatus});
  @override
  List<Object?> get props => [myStatus];
}

class GetMyStatusFailure extends GetMyStatusState {
  final String error;
  const GetMyStatusFailure({required this.error});
  @override
  List<Object> get props => [error];
}
