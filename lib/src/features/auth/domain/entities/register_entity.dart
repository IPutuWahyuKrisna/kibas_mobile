import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String noPelanggan;
  final String namaPelanggan;
  final String nikPelanggan;
  final String alamatPelanggan;
  final int golonganId;
  final int kecamatanId;
  final int kelurahanId;
  final int areaId;

  const RegisterEntity({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.noPelanggan,
    required this.namaPelanggan,
    required this.nikPelanggan,
    required this.alamatPelanggan,
    required this.golonganId,
    required this.kecamatanId,
    required this.kelurahanId,
    required this.areaId,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirmation,
        noPelanggan,
        namaPelanggan,
        nikPelanggan,
        alamatPelanggan,
        golonganId,
        kecamatanId,
        kelurahanId,
        areaId,
      ];
}
