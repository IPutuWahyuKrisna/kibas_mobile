import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/read_meter.dart';
import '../../domain/usecases/fetch_read_meter_usecase.dart';
import '../../domain/usecases/post_meter_usecase.dart';

part 'read_meter_event.dart';
part 'read_meter_state.dart';

class ReadMeterBloc extends Bloc<ReadMeterEvent, ReadMeterState> {
  final GetListMeterUseCase getListMeterUseCase;
  final SubmitPostmeterUseCase postMeterUseCase;

  ReadMeterBloc({
    required this.getListMeterUseCase,
    required this.postMeterUseCase, // ✅ Tambahkan postMeterUseCase ke dalam konstruktor
  }) : super(ReadMeterInitial()) {
    on<GetListMeterEvent>(_onGetListMeter);
    on<PostMeterRequested>(
        _onSubmitPostmeter); // ✅ Tambahkan handler event untuk postmeter
  }

  /// 🔹 Fetch Data Read Meter (GET)
  Future<void> _onGetListMeter(
    GetListMeterEvent event,
    Emitter<ReadMeterState> emit,
  ) async {
    emit(ReadMeterLoading());

    final result = await getListMeterUseCase.execute();

    result.fold(
      (failure) => emit(ReadMeterError(message: failure.message)),
      (data) => emit(ReadMeterLoaded(meterList: data)),
    );
  }

  /// 🔹 Submit Post Meter (POST)
  Future<void> _onSubmitPostmeter(
    PostMeterRequested event,
    Emitter<ReadMeterState> emit,
  ) async {
    emit(PostmeterLoading());

    final result = await postMeterUseCase.execute(
      imageFile: event.imageFile,
      angkaFinal: event.angkaFinal,
    );

    result.fold(
      (failure) => emit(
          PostMeterFailure(failure.message)), // ✅ Error khusus untuk postmeter
      (response) => emit(PostMeterSuccess(response)),
    );
  }
}
