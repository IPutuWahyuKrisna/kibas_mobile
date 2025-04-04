import '../../domain/entities/put_user_profile.dart';

class EditUserModel extends PutUserProfileEntity {
  const EditUserModel({
    required super.email,
    required super.password,
    required super.passwordConfirmation,
    required super.noPelanggan,
    required super.namaPelanggan,
    required super.nikPelanggan,
    required super.alamatPelanggan,
    required super.golonganId,
    required super.kecamatanId,
    required super.kelurahanId,
    required super.areaId,
  });

  factory EditUserModel.fromJson(Map<String, dynamic> json) {
    return EditUserModel(
      email: json['email'],
      password: json['password'],
      passwordConfirmation: json['password_confirmation'],
      noPelanggan: json['no_pelanggan'],
      namaPelanggan: json['nama_pelanggan'],
      nikPelanggan: json['nik_pelanggan'],
      alamatPelanggan: json['alamat_pelanggan'],
      golonganId: json['golongan_id'],
      kecamatanId: json['kecamatan_id'],
      kelurahanId: json['kelurahan_id'],
      areaId: json['area_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "no_pelanggan": noPelanggan,
      "nama_pelanggan": namaPelanggan,
      "nik_pelanggan": nikPelanggan,
      "alamat_pelanggan": alamatPelanggan,
      "golongan_id": golonganId,
      "kecamatan_id": kecamatanId,
      "kelurahan_id": kelurahanId,
      "area_id": areaId,
    };
  }
}
