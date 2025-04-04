import 'dart:io';

import 'package:equatable/equatable.dart';

class PostComplaintEntity extends Equatable {
  final File image;
  final String complaint;

  const PostComplaintEntity({
    required this.image,
    required this.complaint,
  });

  @override
  List<Object?> get props => [image, complaint];
}
