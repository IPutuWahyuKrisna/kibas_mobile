part of 'rekening_bloc.dart';

abstract class RekeningState extends Equatable {
  const RekeningState();

  @override
  List<Object> get props => [];
}

class RekeningInitial extends RekeningState {
  @override
  List<Object> get props => [];
}

class RekeningLoading extends RekeningState {
  @override
  List<Object> get props => [];
}

class TagihanLoaded extends RekeningState {
  final List<TagihanEntity> tagihanList;

  const TagihanLoaded(this.tagihanList);

  @override
  List<Object> get props => [tagihanList];
}

class TagihanError extends RekeningState {
  final String message;

  const TagihanError(this.message);

  @override
  List<Object> get props => [message];
}

class RekeningLoaded extends RekeningState {
  final List<RekeningEntity> rekeningList;

  const RekeningLoaded(this.rekeningList);

  @override
  List<Object> get props => [rekeningList];
}

class RekeningError extends RekeningState {
  final String message;

  const RekeningError(this.message);

  @override
  List<Object> get props => [message];
}

class RekeningDetailInitial extends RekeningState {
  @override
  List<Object> get props => [];
}

class RekeningDetailLoading extends RekeningState {
  @override
  List<Object> get props => [];
}

class TagihanLoading extends RekeningState {
  @override
  List<Object> get props => [];
}

class RekeningDetailLoaded extends RekeningState {
  final RekeningDetailEntity rekeningDetail;
  final Map<String, dynamic> labelMapping;

  const RekeningDetailLoaded(this.rekeningDetail, this.labelMapping);

  @override
  List<Object> get props => [rekeningDetail, labelMapping];
}

class RekeningDetailError extends RekeningState {
  final String message;

  const RekeningDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class DropdownLoadingRekening extends RekeningState {}

/// 🔹 State ketika data dropdown berhasil dimuat
class RekeningDropdownLoaded extends RekeningState {
  final List<Map<String, dynamic>> areaList;
  final List<Map<String, dynamic>> kecamatanList;
  final List<Map<String, dynamic>> kelurahanList;
  final List<Map<String, dynamic>> golonganList;
  final List<Map<String, dynamic>> rayonList;

  const RekeningDropdownLoaded({
    required this.areaList,
    required this.kecamatanList,
    required this.kelurahanList,
    required this.golonganList,
    required this.rayonList,
  });

  @override
  List<Object> get props =>
      [areaList, kecamatanList, kelurahanList, golonganList, rayonList];
}

/// 🔹 State ketika rekening berhasil ditambahkan
class RekeningSuccess extends RekeningState {
  final String message;

  const RekeningSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class PutRekeningLoading extends RekeningState {}

class PutRekeningSuccess extends RekeningState {
  final String message;

  const PutRekeningSuccess(this.message);

  @override
  List<Object> get props => [message];
}
