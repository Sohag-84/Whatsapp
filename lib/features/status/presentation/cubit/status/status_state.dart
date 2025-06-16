part of 'status_cubit.dart';

sealed class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object> get props => [];
}

final class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {
  @override
  List<Object> get props => [];
}

class StatusLoaded extends StatusState {
  final List<StatusEntity> statuses;

  const StatusLoaded({required this.statuses});
  @override
  List<Object> get props => [statuses];
}

class StatusFailure extends StatusState {
  final String error;
  const StatusFailure({required this.error});
  @override
  List<Object> get props => [error];
}
