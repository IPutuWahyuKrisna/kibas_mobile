import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  factory ServerException.fromDioError(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return ServerException(
            "Permintaan tidak valid, periksa kembali data yang Anda masukkan.");
      case 401:
        return ServerException("Unauthorized! Anda tidak memiliki akses.");
      case 403:
        return ServerException(
            "Forbidden! Anda tidak memiliki izin untuk mengakses sumber daya ini.");
      case 404:
        return ServerException(
            "Data tidak ditemukan, pastikan email dan password benar.");
      case 422:
        return ServerException(
            "Data tidak ditemukan, pastikan pengguna sudah terdaftar.");
      case 500:
        return ServerException("Terjadi kesalahan di server, coba lagi nanti.");
      default:
        return ServerException("Terjadi kesalahan yang tidak diketahui.");
    }
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);
}
