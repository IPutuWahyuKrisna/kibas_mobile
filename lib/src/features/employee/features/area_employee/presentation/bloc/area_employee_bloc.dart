import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/area_pegawai_entity.dart';
import '../../domain/usecases/get_area_pegawai_usecase.dart';

part 'area_employee_event.dart';
part 'area_employee_state.dart';

class AreaEmployeeBloc extends Bloc<AreaEmployeeEvent, AreaEmployeeState> {
  final GetAreaPegawaiUseCase getAreaPegawaiUseCase;

  AreaEmployeeBloc(this.getAreaPegawaiUseCase) : super(AreaPegawaiInitial()) {
    on<FetchAreaPegawaiEvent>(_onFetchAreaPegawai);
  }

  Future<void> _onFetchAreaPegawai(
      FetchAreaPegawaiEvent event, Emitter<AreaEmployeeState> emit) async {
    emit(AreaPegawaiLoading());
    final result = await getAreaPegawaiUseCase.execute(event.token);
    result.fold(
      (failure) => emit(AreaPegawaiError(message: failure.message)),
      (data) => emit(AreaPegawaiLoaded(areaPegawai: data)),
    );
  }
}
