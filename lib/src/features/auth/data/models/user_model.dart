import '../../domain/entities/user_entity.dart';
import 'pegawai_model.dart';
import 'pelanggan_model.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.role,
    required super.token,
    PegawaiModel? super.pegawai,
    PelangganModel? super.pelanggan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Akses objek 'data' terlebih dahulu
    return UserModel(
      email: json['email'],
      role: json['role'],
      token: json['token'],
      pegawai: json['additional']?['pegawai'] != null
          ? PegawaiModel.fromJson(
              Map<String, dynamic>.from(json['additional']['pegawai']))
          : null,
      pelanggan: json['additional']?['pelanggan'] != null
          ? PelangganModel.fromJson(
              Map<String, dynamic>.from(json['additional']['pelanggan']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'token': token,
      'additional': {
        'pegawai': pegawai != null ? (pegawai as PegawaiModel).toJson() : null,
        'pelanggan':
            pelanggan != null ? (pelanggan as PelangganModel).toJson() : null,
      },
    };
  }
}
