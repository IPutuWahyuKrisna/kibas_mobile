import 'dart:io';
import 'package:equatable/equatable.dart';

class PostComplaintEntity extends Equatable {
  final File image;
  final String complaint;
  final double latitude;
  final double longitude;
  final String jenisPengaduan;

  const PostComplaintEntity({
    required this.image,
    required this.complaint,
    required this.latitude,
    required this.longitude,
    required this.jenisPengaduan,
  });

  @override
  List<Object?> get props =>
      [image, complaint, latitude, longitude, jenisPengaduan];
}
