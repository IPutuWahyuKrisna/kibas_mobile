part of 'rekening_bloc.dart';

abstract class RekeningEvent extends Equatable {
  const RekeningEvent();

  @override
  List<Object> get props => [];
}

class FetchRekeningEvent extends RekeningEvent {
  final int pelangganId;

  const FetchRekeningEvent(this.pelangganId);

  @override
  List<Object> get props => [pelangganId];
}

class FetchRekeningDetailEvent extends RekeningEvent {
  final int rekeningId;

  const FetchRekeningDetailEvent(this.rekeningId);

  @override
  List<Object> get props => [rekeningId];
}

class FetchDropdownDataEvent extends RekeningEvent {}

/// 🔹 Event untuk menambahkan rekening baru
class PostRekeningEvent extends RekeningEvent {
  final Map<String, dynamic> data;

  const PostRekeningEvent(this.data);

  @override
  List<Object> get props => [data];
}

class PutRekeningEvent extends RekeningEvent {
  final Map<String, dynamic> data;

  const PutRekeningEvent(this.data);

  @override
  List<Object> get props => [data];
}
