import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/complaint_entity.dart';
import '../../domain/usecases/get_all_complaints_usecase.dart';
import '../../domain/usecases/get_complaint_detail_usecase.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final GetAllComplaintsUseCase getAllComplaints;
  final GetComplaintDetailUseCase getComplaintDetail;

  ComplaintBloc({
    required this.getAllComplaints,
    required this.getComplaintDetail,
  }) : super(ComplaintInitial()) {
    on<FetchAllComplaintsEvent>(_onFetchAllComplaints);
    on<FetchComplaintDetailEvent>(_onFetchComplaintDetail);
  }

  Future<void> _onFetchAllComplaints(
      FetchAllComplaintsEvent event, Emitter<ComplaintState> emit) async {
    emit(ComplaintLoading());
    final result = await getAllComplaints(event.token);
    result.fold(
      (failure) => emit(ComplaintError(message: failure.message)),
      (data) => emit(AllComplaintsLoaded(complaints: data)),
    );
  }

  Future<void> _onFetchComplaintDetail(
      FetchComplaintDetailEvent event, Emitter<ComplaintState> emit) async {
    emit(ComplaintLoading());
    final result = await getComplaintDetail(event.token, event.id);
    result.fold(
      (failure) => emit(ComplaintError(message: failure.message)),
      (data) => emit(ComplaintDetailLoaded(complaint: data)),
    );
  }
}
