import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String noRekening;
  final String nikPelanggan;
  final String noTelepon;

  const RegisterEntity({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.noRekening,
    required this.nikPelanggan,
    required this.noTelepon,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirmation,
        noRekening,
        nikPelanggan,
        noTelepon
      ];
}
