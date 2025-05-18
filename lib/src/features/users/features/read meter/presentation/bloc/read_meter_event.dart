part of 'read_meter_bloc.dart';

abstract class ReadMeterEvent extends Equatable {
  const ReadMeterEvent();

  @override
  List<Object?> get props => [];
}

class FetchReadMeterEvent extends ReadMeterEvent {
  final String token;

  const FetchReadMeterEvent({required this.token});
}

class GetListMeterEvent extends ReadMeterEvent {
  final String token;

  const GetListMeterEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class PostMeterRequested extends ReadMeterEvent {
  final File imageFile;
  final String noRekening;
  final String angkaFinal;

  const PostMeterRequested({
    required this.imageFile,
    required this.noRekening,
    required this.angkaFinal,
  });

  @override
  List<Object> get props => [imageFile, noRekening, angkaFinal];
}
