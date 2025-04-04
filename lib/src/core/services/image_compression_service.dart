import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageProcessor {
  /// 🔹 Kompres gambar jika lebih dari 2MB dan ubah format ke JPG
  Future<File?> compressImage(File imageFile) async {
    const int maxSize = 2 * 1024 * 1024; // 2MB

    // Jika gambar sudah di bawah 2MB, langsung return file asli
    if (imageFile.lengthSync() <= maxSize) {
      return imageFile;
    }

    try {
      // 🔹 Baca file sebagai bytes
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        return null;
      }

      // 🔹 Resize gambar jika terlalu besar (opsional)
      final resizedImage = img.copyResize(image, width: 1080);

      // 🔹 Simpan dalam format JPG dengan kualitas 85%
      final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

      // 🔹 Simpan gambar ke direktori sementara
      final tempDir = await getTemporaryDirectory();
      final compressedFile = File('${tempDir.path}/compressed_image.jpg')
        ..writeAsBytesSync(compressedBytes);

      // 🔹 Pastikan file hasil kompresi di bawah 2MB
      if (compressedFile.lengthSync() > maxSize) {
        return null; // Jika masih lebih dari 2MB, return null
      }

      return compressedFile;
    } catch (e) {
      return null;
    }
  }
}
