import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failure.dart';
import '../../domain/entities/rekening_detail_entity.dart';
import '../../domain/entities/rekening_entity.dart';
import '../../domain/usecases/get_dropdownd_rekening.dart';
import '../../domain/usecases/get_rekening_detail_usecase.dart';
import '../../domain/usecases/get_rekening_usecase.dart';
import '../../domain/usecases/post_rekening_usecase.dart';
import '../../domain/usecases/put_rekening_usecase.dart'; // Pastikan impor ini ada

part 'rekening_event.dart';
part 'rekening_state.dart';

class RekeningBloc extends Bloc<RekeningEvent, RekeningState> {
  final GetRekeningUseCase getRekeningUseCase;
  final GetRekeningDetailUseCase getRekeningDetailUseCase;
  final GetGolonganListUseCase getGolonganListUseCase;
  final GetKecamatanListUseCase getKecamatanListUseCase;
  final GetKelurahanListUseCase getKelurahanListUseCase;
  final GetAreaListUseCase getAreaListUseCase;
  final GetRayonListUseCase getRayonListUseCase;
  final PostRekeningUseCase postRekeningUseCase; // Tambahkan field ini
  final PutRekeningUseCase putRekeningUseCase;

  RekeningBloc(
      {required this.getRekeningUseCase,
      required this.getRekeningDetailUseCase,
      required this.getGolonganListUseCase,
      required this.getKecamatanListUseCase,
      required this.getKelurahanListUseCase,
      required this.getAreaListUseCase,
      required this.getRayonListUseCase,
      required this.postRekeningUseCase,
      required this.putRekeningUseCase // Pastikan dependency disertakan
      })
      : super(RekeningInitial()) {
    on<FetchRekeningEvent>(_onFetchRekening);
    on<FetchRekeningDetailEvent>(_onFetchRekeningDetail);
    on<FetchDropdownDataEvent>(_onFetchDropdownRekening);
    on<PostRekeningEvent>(_onPostRekening);
    on<PutRekeningEvent>(_onPutRekening); // Registrasi event handler untuk POST
  }

  Future<void> _onFetchRekening(
      FetchRekeningEvent event, Emitter<RekeningState> emit) async {
    emit(RekeningLoading());

    final Either<Failure, List<RekeningEntity>> result =
        await getRekeningUseCase(event.pelangganId);

    result.fold(
      (failure) => emit(RekeningError(failure.message)),
      (rekeningList) => emit(RekeningLoaded(rekeningList)),
    );
  }

  Future<void> _onFetchRekeningDetail(
      FetchRekeningDetailEvent event, Emitter<RekeningState> emit) async {
    emit(RekeningDetailLoading());

    final detailResult = await getRekeningDetailUseCase(event.rekeningId);
    final golongan = await getGolonganListUseCase.execute();
    final kecamatan = await getKecamatanListUseCase.execute();
    final kelurahan = await getKelurahanListUseCase.execute();
    final area = await getAreaListUseCase.execute();
    final rayon = await getRayonListUseCase.execute();

    detailResult.fold(
      (failure) => emit(RekeningDetailError(failure.message)),
      (rekening) {
        final golonganName =
            _lookupName(golongan, rekening.golonganId, 'id', 'golongan');
        final kecamatanName =
            _lookupName(kecamatan, rekening.kecamatanId, 'id', 'kecamatan');
        final kelurahanName =
            _lookupName(kelurahan, rekening.kelurahanId, 'id', 'kelurahan');
        final areaName = _lookupName(area, rekening.areaId, 'id', 'area');
        final rayonCode =
            _lookupName(rayon, rekening.rayonId, 'id', 'kode_rayon');

        print(
            "golongan: $golonganName kecamatan: $kecamatanName kelurahan: $kelurahanName area: $areaName rayon: $rayonCode");

        emit(RekeningDetailLoaded(rekening, {
          "golongan": golonganName,
          "kecamatan": kecamatanName,
          "kelurahan": kelurahanName,
          "area": areaName,
          "rayon": rayonCode,
        }));
      },
    );
  }

  Future<void> _onFetchDropdownRekening(
      FetchDropdownDataEvent event, Emitter<RekeningState> emit) async {
    emit(DropdownLoadingRekening());

    final golonganResult = await getGolonganListUseCase.execute();
    final kecamatanResult = await getKecamatanListUseCase.execute();
    final kelurahanResult = await getKelurahanListUseCase.execute();
    final areaResult = await getAreaListUseCase.execute();
    final rayonResult = await getRayonListUseCase.execute();

    emit(RekeningDropdownLoaded(
      golonganList: golonganResult.getOrElse(() => []),
      kecamatanList: kecamatanResult.getOrElse(() => []),
      kelurahanList: kelurahanResult.getOrElse(() => []),
      areaList: areaResult.getOrElse(() => []),
      rayonList: rayonResult.getOrElse(() => []),
    ));
  }

  Future<void> _onPostRekening(
      PostRekeningEvent event, Emitter<RekeningState> emit) async {
    emit(RekeningLoading());
    final Either<Failure, RekeningEntity> result =
        await postRekeningUseCase(event.data);
    result.fold(
      (failure) => emit(RekeningError(failure.message)),
      (rekening) =>
          emit(const RekeningSuccess("Berhasil menambahkan rekening")),
    );
  }

  Future<void> _onPutRekening(
      PutRekeningEvent event, Emitter<RekeningState> emit) async {
    emit(PutRekeningLoading());
    final Either<Failure, RekeningEntity> result =
        await putRekeningUseCase(event.data);
    result.fold(
      (failure) => emit(RekeningError(failure.message)),
      (rekening) =>
          emit(const PutRekeningSuccess("Data rekening berhasil diperbarui")),
    );
  }
}

String _lookupName(
  Either<Failure, List<Map<String, dynamic>>> result,
  int id,
  String idKey,
  String labelKey,
) {
  return result.fold(
    (_) => "-",
    (list) {
      final match = list.firstWhere(
        (item) => item[idKey].toString() == id.toString(),
        orElse: () => {},
      );
      return match[labelKey]?.toString() ?? "-";
    },
  );
}
