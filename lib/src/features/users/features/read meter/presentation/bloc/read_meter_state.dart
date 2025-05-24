part of 'read_meter_bloc.dart';

abstract class ReadMeterState extends Equatable {
  const ReadMeterState();

  @override
  List<Object?> get props => [];
}

class ReadMeterInitial extends ReadMeterState {}

class ReadMeterLoading extends ReadMeterState {}

class PostmeterLoading extends ReadMeterState {}

class ReadMeterLoaded extends ReadMeterState {
  final List<ReadMeterEntity> meterList;

  const ReadMeterLoaded({required this.meterList});

  @override
  List<Object?> get props => [meterList];
}

class ReadMeterError extends ReadMeterState {
  final String message;

  const ReadMeterError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PostMeterLoading extends ReadMeterState {}

class PostMeterSuccess extends ReadMeterState {
  final String message;

  const PostMeterSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class PostMeterFailure extends ReadMeterState {
  final String error;

  const PostMeterFailure(this.error);

  @override
  List<Object> get props => [error];
}
