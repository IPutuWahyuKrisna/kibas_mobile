part of 'complaint_bloc.dart';

abstract class ComplaintEvent extends Equatable {
  const ComplaintEvent();

  @override
  List<Object> get props => [];
}

// Event untuk fetch semua pengaduan oleh pegawai
class FetchComplaintsEvent extends ComplaintEvent {}

// Event untuk submit penyelesaian pengaduan
class SubmitComplaintEvent extends ComplaintEvent {
  final int pengaduanId;
  final File buktiFotoSelesai;
  final String catatan;

  const SubmitComplaintEvent({
    required this.pengaduanId,
    required this.buktiFotoSelesai,
    required this.catatan,
  });

  @override
  List<Object> get props => [pengaduanId, buktiFotoSelesai, catatan];
}
