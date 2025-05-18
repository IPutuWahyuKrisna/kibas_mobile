import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String noPelanggan;
  final String noRekening;
  final String nikPelanggan;

  const RegisterEntity({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.noPelanggan,
    required this.noRekening,
    required this.nikPelanggan,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirmation,
        noPelanggan,
        noRekening,
        nikPelanggan,
      ];
}
