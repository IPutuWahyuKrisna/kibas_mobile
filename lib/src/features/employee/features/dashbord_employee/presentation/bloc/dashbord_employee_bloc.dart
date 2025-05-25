import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/announcement_entity.dart';
import '../../domain/usecases/get_all_announcement_usecase.dart';
import '../../domain/usecases/log_out_usecase.dart';

part 'dashbord_employee_event.dart';
part 'dashbord_employee_state.dart';

class DashbordEmployeeBloc
    extends Bloc<DashbordEmployeeEvent, DashbordEmployeeState> {
  final GetAllAnnouncementsUseCase getAllAnnouncementsUseCase;
  final LogoutUseCase logoutUseCase;

  DashbordEmployeeBloc({
    required this.getAllAnnouncementsUseCase,
    required this.logoutUseCase,
  }) : super(DashbordEmployeeInitial()) {
    on<GetAnnouncementsEvent>(_onGetAnnouncements);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onGetAnnouncements(
      GetAnnouncementsEvent event, Emitter<DashbordEmployeeState> emit) async {
    emit(DashboardLoading());
    final result = await getAllAnnouncementsUseCase.execute(event.token);
    print(result);
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (announcements) => emit(DashboardLoaded(announcements)),
    );
  }

  Future<void> _onLogout(
      LogoutEvent event, Emitter<DashbordEmployeeState> emit) async {
    emit(DashboardLoading());
    final result = await logoutUseCase.execute();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (logout) => emit(DashboardLoggedOut(logout.message)),
    );
  }
}
