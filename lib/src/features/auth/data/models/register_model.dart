import '../../domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel(
      {required super.email,
      required super.password,
      required super.passwordConfirmation,
      required super.noRekening,
      required super.nikPelanggan});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
        email: json['email'],
        password: json['password'],
        passwordConfirmation: json['password_confirmation'],
        noRekening: json['no_sambungan'],
        nikPelanggan: json['nik']);
  }

  Map<String, dynamic> toJson() {
    return {
      "no_sambungan": noRekening,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "nik": nikPelanggan
    };
  }
}
