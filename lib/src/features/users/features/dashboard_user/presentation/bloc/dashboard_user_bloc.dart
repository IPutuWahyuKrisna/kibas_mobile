import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:kibas_mobile/src/features/users/features/dashboard_user/domain/entities/put_user_profile.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../../../../../auth/data/models/user_model.dart';
import '../../../../../auth/domain/usecases/get_dropdown_usecases.dart';
import '../../data/models/edit_user.dart';
import '../../domain/repositories/put_user_repository_domain.dart';

part 'dashboard_user_event.dart';
part 'dashboard_user_state.dart';

class DashboardUserBloc extends Bloc<DashboardUserEvent, DashboardUserState> {
  final PutUserRepositoryDomain putRepository;
  final GetGolonganListUseCase getGolonganListUseCase;
  final GetKecamatanListUseCase getKecamatanListUseCase;
  final GetKelurahanListUseCase getKelurahanListUseCase;
  final GetAreaListUseCase getAreaListUseCase;

  DashboardUserBloc({
    required this.putRepository,
    required this.getGolonganListUseCase,
    required this.getKecamatanListUseCase,
    required this.getKelurahanListUseCase,
    required this.getAreaListUseCase,
  }) : super(DashboardUserInitial()) {
    on<PutUsersEvent>(_onPutUserProfile);
    on<FetchDropdownEvent>(_onFetchDropdown);
  }

  Future<void> _onPutUserProfile(
      PutUsersEvent event, Emitter<DashboardUserState> emit) async {
    emit(DashboardUserStateLoading());

    final EditUserModel editUserModel = EditUserModel(
      email: event.putUsers.email,
      password: event.putUsers.password,
      passwordConfirmation: event.putUsers.passwordConfirmation,
      noPelanggan: event.putUsers.noPelanggan,
      namaPelanggan: event.putUsers.namaPelanggan,
      nikPelanggan: event.putUsers.nikPelanggan,
      alamatPelanggan: event.putUsers.alamatPelanggan,
      golonganId: event.putUsers.golonganId,
      kecamatanId: event.putUsers.kecamatanId,
      kelurahanId: event.putUsers.kelurahanId,
      areaId: event.putUsers.areaId,
    );

    final result = await putRepository.putUser(editUserModel);

    await result.fold(
      (failure) async => emit(PutUserError(message: failure.message)),
      (message) async {
        // Setelah PUT berhasil, panggil API GET untuk refresh data user
        try {
          final dio =
              coreInjection<Dio>(); // Pastikan Dio sudah di-register di GetIt
          final userService = coreInjection<UserLocalStorageService>();
          final user = userService.getUser();
          final token = user?.token ?? "";
          final response = await dio.get(
            'https://kibas.tirtadanuarta.com/api/v1/pelanggan',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          if (response.statusCode == 200 && response.data['code'] == 200) {
            final userModel = UserModel.fromJson(response.data['data']);
            await userService.clearUser();
            await userService.saveUser(userModel);
          }
          // ignore: empty_catches
        } catch (e) {}
        emit(PutUserSuccess(message: message));
      },
    );
  }

  Future<void> _onFetchDropdown(
      FetchDropdownEvent event, Emitter<DashboardUserState> emit) async {
    emit(DropdownLoading());

    final golonganResult = await getGolonganListUseCase.execute();
    final kecamatanResult = await getKecamatanListUseCase.execute();
    final kelurahanResult = await getKelurahanListUseCase.execute();
    final areaResult = await getAreaListUseCase.execute();

    emit(DropdownLoadedUsers(
      golonganList: golonganResult.getOrElse(() => []),
      kecamatanList: kecamatanResult.getOrElse(() => []),
      kelurahanList: kelurahanResult.getOrElse(() => []),
      areaList: areaResult.getOrElse(() => []),
    ));
  }
}
