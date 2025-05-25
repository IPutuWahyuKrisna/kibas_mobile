import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/myannouncement.dart';
import '../../domain/usecases/fetch_my_announcements_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FetchMyAnnouncementsUseCase fetchUseCase;

  NotificationBloc(this.fetchUseCase) : super(NotificationInitial()) {
    on<FetchMyAnnouncementsEvent>(_onFetchMyAnnouncements);
  }

  Future<void> _onFetchMyAnnouncements(
    FetchMyAnnouncementsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await fetchUseCase.execute();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (data) => emit(NotificationLoaded(data)),
    );
  }
}
