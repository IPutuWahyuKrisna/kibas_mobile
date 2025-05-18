import '../../domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel(
      {required super.email,
      required super.password,
      required super.passwordConfirmation,
      required super.noPelanggan,
      required super.noRekening,
      required super.nikPelanggan});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
        email: json['email'],
        password: json['password'],
        passwordConfirmation: json['password_confirmation'],
        noPelanggan: json['no_pelanggan'],
        noRekening: json['no_rekening'],
        nikPelanggan: json['nik_pelanggan']);
  }

  Map<String, dynamic> toJson() {
    return {
      "no_pelanggan": noPelanggan,
      "no_rekening": noRekening,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "nik_pelanggan": nikPelanggan
    };
  }
}
