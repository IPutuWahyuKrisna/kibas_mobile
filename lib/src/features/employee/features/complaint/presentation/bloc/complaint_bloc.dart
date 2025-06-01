import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/complaint_entity.dart';
import '../../domain/usecases/get_all_complaints_usecase.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintEmployeeBloc
    extends Bloc<ComplaintEmployeeEvent, ComplaintEmployeeState> {
  final GetAllComplaintEmployeeUseCase getAllComplaintEmployeeUseCase;

  ComplaintEmployeeBloc({
    required this.getAllComplaintEmployeeUseCase,
  }) : super(ComplaintEmployeeInitial()) {
    on<GetAllComplaintEmployeeEvent>(_onGetAllComplaintEmployee);
  }

  Future<void> _onGetAllComplaintEmployee(
    GetAllComplaintEmployeeEvent event,
    Emitter<ComplaintEmployeeState> emit,
  ) async {
    emit(ComplaintEmployeeLoading());
    try {
      final complaints = await getAllComplaintEmployeeUseCase();
      emit(ComplaintEmployeeLoaded(complaints));
    } catch (e) {
      emit(ComplaintEmployeeError(e.toString()));
    }
  }
}
