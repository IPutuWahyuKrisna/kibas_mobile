import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  factory ServerException.fromDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message =
        error.response?.statusMessage ?? "Terjadi kesalahan pada server";

    switch (statusCode) {
      case 400:
        return ServerException(
          "Permintaan tidak valid, periksa kembali data yang Anda masukkan.",
          statusCode: statusCode,
        );
      case 401:
        return const UnauthenticatedException(
            "Sesi Anda telah berakhir, silakan login kembali");
      case 403:
        return ServerException(
          "Forbidden! Anda tidak memiliki izin untuk mengakses sumber daya ini.",
          statusCode: statusCode,
        );
      case 404:
        return ServerException(
          "Data tidak ditemukan, pastikan email dan password benar.",
          statusCode: statusCode,
        );
      case 422:
        return ServerException(
          "Data tidak valid, pastikan pengguna sudah terdaftar.",
          statusCode: statusCode,
        );
      case 500:
        return ServerException(
          "Terjadi kesalahan di server, coba lagi nanti.",
          statusCode: statusCode,
        );
      default:
        return ServerException(
          message,
          statusCode: statusCode,
        );
    }
  }
}

class UnauthenticatedException extends ServerException {
  const UnauthenticatedException(super.message) : super(statusCode: 401);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class UnknownException implements Exception {
  final String message;
  const UnknownException(this.message);
}
