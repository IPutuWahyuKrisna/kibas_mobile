import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/register_entity.dart';
import '../../domain/repositories/login_repository_domain.dart';
import '../../domain/usecases/get_dropdown_usecases.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final RegisterUseCase registerUseCase;
  final GetGolonganListUseCase getGolonganListUseCase;
  final GetKecamatanListUseCase getKecamatanListUseCase;
  final GetKelurahanListUseCase getKelurahanListUseCase;
  final GetAreaListUseCase getAreaListUseCase;

  AuthBloc({
    required this.authRepository,
    required this.registerUseCase,
    required this.getGolonganListUseCase,
    required this.getKecamatanListUseCase,
    required this.getKelurahanListUseCase,
    required this.getAreaListUseCase,
  }) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<SubmitRegisterEvent>(_onSubmitRegister);
    on<FetchDropdownEvent>(_onFetchDropdown);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());
    final result = await authRepository.login(event.email, event.password);
    print("masuk bloc");
    result.fold(
      (failure) {
        emit(AuthStateFailure(failure.message));
      },
      (userModel) {
        emit(AuthStateSuccess(userModel)); // 🟢 Emit Success
      },
    );
  }

  /// 🔹 Proses Register
  Future<void> _onSubmitRegister(
      SubmitRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());

    final result = await registerUseCase.execute(event.registerData);

    result.fold(
      (failure) => emit(RegisterError(message: failure.message)),
      (message) => emit(RegisterSuccess(message: message)),
    );
  }

  /// 🔹 Fetch Data Dropdown (Golongan, Kecamatan, Kelurahan, Area)
  Future<void> _onFetchDropdown(
      FetchDropdownEvent event, Emitter<AuthState> emit) async {
    emit(DropdownLoading());

    final golonganResult = await getGolonganListUseCase.execute();
    final kecamatanResult = await getKecamatanListUseCase.execute();
    final kelurahanResult = await getKelurahanListUseCase.execute();
    final areaResult = await getAreaListUseCase.execute();

    emit(DropdownLoaded(
      golonganList: golonganResult.getOrElse(() => []),
      kecamatanList: kecamatanResult.getOrElse(() => []),
      kelurahanList: kelurahanResult.getOrElse(() => []),
      areaList: areaResult.getOrElse(() => []),
    ));
  }
}
