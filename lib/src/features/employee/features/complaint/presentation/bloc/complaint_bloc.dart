// complaint_bloc.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/usecases/get_all_complaints_usecase.dart';
import '../../domain/usecases/post_complaint_employee_usecase.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final FetchComplaintEmployeeUseCase fetchComplaints;
  final PostComplaintEmployeeUseCase postComplaint;

  ComplaintBloc({
    required this.fetchComplaints,
    required this.postComplaint,
  }) : super(ComplaintInitial()) {
    on<FetchComplaintsEvent>(_onFetchComplaints);
    on<SubmitComplaintEvent>(_onSubmitComplaint);
  }

  Future<void> _onFetchComplaints(
    FetchComplaintsEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(ComplaintLoading());

    final result = await fetchComplaints();

    result.fold(
      (failure) => emit(
        ComplaintError(
          message: failure.message ?? 'Gagal memuat data',
          failureType: _mapFailure(failure),
        ),
      ),
      (data) => emit(ComplaintLoaded(complaints: data)),
    );
  }

  Future<void> _onSubmitComplaint(
    SubmitComplaintEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(ComplaintSubmitting());

    final result = await postComplaint.execute(
      pengaduanId: event.pengaduanId,
      buktiFotoSelesai: event.buktiFotoSelesai,
      catatan: event.catatan,
    );
    print(result);
    result.fold(
      (failure) => emit(
        ComplaintError(
          message: failure.message ?? 'Gagal mengirim penyelesaian',
          failureType: _mapFailure(failure),
        ),
      ),
      (message) => emit(ComplaintSubmittedSuccess(message: message)),
    );
  }

  ComplaintFailureType _mapFailure(Failure failure) {
    if (failure is UnauthenticatedFailure) {
      return ComplaintFailureType.unauthenticated;
    }
    if (failure is ServerFailure) return ComplaintFailureType.server;
    if (failure is NetworkFailure) return ComplaintFailureType.network;
    return ComplaintFailureType.unknown;
  }
}
