import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kibas_mobile/src/features/users/features/complaint_users/domain/entities/detail_complain.dart';

import '../../data/models/put_complaint_model.dart';
import '../../domain/entities/complaint_users_entity.dart';
import '../../domain/usecases/delete_complaint.dart';
import '../../domain/usecases/get_all_complaints_users_usecase.dart';
import '../../domain/usecases/get_complaint_detail_users_usecase.dart';
import '../../domain/usecases/post_complaint_usecase.dart';
import '../../domain/usecases/put_complaint_usecase.dart';

part 'complaint_usres_event.dart';
part 'complaint_usres_state.dart';

class ComplaintUsersBloc
    extends Bloc<ComplaintUsersEvent, ComplaintUsersState> {
  final PutComplaintUseCase putComplaintUseCase;
  final GetAllComplaintsUsersUseCase getAllComplaints;
  final GetComplaintDetailUsersUseCase getComplaintDetail;
  final PostComplaintUseCase postComplaintUseCase;
  final DeleteComplaintUseCase deleteComplaintUseCase;

  ComplaintUsersBloc({
    required this.putComplaintUseCase,
    required this.postComplaintUseCase,
    required this.getAllComplaints,
    required this.getComplaintDetail,
    required this.deleteComplaintUseCase,
  }) : super(ComplaintUsersInitial()) {
    on<FetchAllComplaintsUsersEvent>(_onFetchAllComplaints);
    on<FetchComplaintDetailUsersEvent>(_onFetchComplaintDetail);
    on<SubmitComplaintEvent>(_onSubmitComplaint);
    on<DeleteComplaintEvent>(_onDeleteComplaint);
    on<SubmitRatingComplaintEvent>(_onSubmitRatingComplaint);
  }

  Future<void> _onFetchAllComplaints(FetchAllComplaintsUsersEvent event,
      Emitter<ComplaintUsersState> emit) async {
    emit(ComplaintUsersLoading());
    final result = await getAllComplaints(event.token);
    print(result);
    result.fold(
      (failure) => emit(ComplaintUsersError(message: failure.message)),
      (data) => emit(AllComplaintsUsersLoaded(complaints: data)),
    );
  }

  Future<void> _onFetchComplaintDetail(FetchComplaintDetailUsersEvent event,
      Emitter<ComplaintUsersState> emit) async {
    emit(ComplaintUsersLoading());
    final result = await getComplaintDetail(event.token, event.id);

    result.fold(
      (failure) => emit(ComplaintUsersError(message: failure.message)),
      (data) => emit(ComplaintDetailUsersLoaded(complaint: data)),
    );
  }

  Future<void> _onSubmitComplaint(
    SubmitComplaintEvent event,
    Emitter<ComplaintUsersState> emit,
  ) async {
    emit(ComplaintUsersLoading());
    final result = await postComplaintUseCase.execute(
      image: event.image,
      complaint: event.complaint,
      latitude: event.latitude,
      longitude: event.longitude,
      jenisPengaduan: event.jenisPengaduan,
    );
    result.fold(
      (failure) => emit(ComplaintUsersError(message: failure.message)),
      (message) => emit(PostComplaintSuccess(message: message)),
    );
  }

  Future<void> _onDeleteComplaint(
      DeleteComplaintEvent event, Emitter<ComplaintUsersState> emit) async {
    emit(ComplaintUsersLoading());

    final result = await deleteComplaintUseCase.execute(event.id);

    result.fold(
      (failure) => emit(ComplaintUsersError(message: failure.message)),
      (message) => emit(DeleteComplaintSuccess(message: message)),
    );
  }

  Future<void> _onSubmitRatingComplaint(
    SubmitRatingComplaintEvent event,
    Emitter<ComplaintUsersState> emit,
  ) async {
    emit(ComplaintUsersLoading());

    final result = await putComplaintUseCase.execute(
      PutComplaintModel(
        pengaduanId: event.pengaduanId,
        rating: event.rating,
      ),
    );
    print(result);
    result.fold(
      (failure) => emit(ComplaintUsersError(message: failure.message)),
      (message) => emit(PutComplaintSuccess(message: message)),
    );
  }
}
