// domain/entities/post_meter_entity.dart
import 'package:equatable/equatable.dart';

class PostmeterEntity extends Equatable {
  final String linkFoto;
  final String noRekening;
  final String angkaFinal;

  const PostmeterEntity({
    required this.linkFoto,
    required this.noRekening,
    required this.angkaFinal,
  });

  @override
  List<Object?> get props => [linkFoto, noRekening, angkaFinal];
}
