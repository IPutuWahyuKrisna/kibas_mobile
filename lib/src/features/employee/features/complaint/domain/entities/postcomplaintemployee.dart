import 'dart:io';
import 'package:equatable/equatable.dart';

class PostComplaintEmployee extends Equatable {
  final int pengaduanId;
  final String catatan;
  final File buktiFoto;

  const PostComplaintEmployee({
    required this.pengaduanId,
    required this.catatan,
    required this.buktiFoto,
  });

  @override
  List<Object?> get props => [pengaduanId, catatan, buktiFoto];
}
