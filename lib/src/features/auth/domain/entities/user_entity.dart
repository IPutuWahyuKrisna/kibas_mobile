import 'pegawai_entity.dart';
import 'pelanggan_entity.dart';

class User {
  final String email;
  final String role;
  final String token;
  final Pegawai? pegawai;
  final Pelanggan? pelanggan;

  User({
    required this.email,
    required this.role,
    required this.token,
    this.pegawai,
    this.pelanggan,
  });
}
