import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_storage/get_storage.dart';

class PermissionService {
  final box = GetStorage(); // 🔥 Inisialisasi GetStorage

  /// 🔹 Meminta izin lokasi & penyimpanan
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    // 🔥 Simpan status izin di GetStorage
    box.write('location_permission', statuses[Permission.location]!.isGranted);
    box.write('storage_permission', statuses[Permission.storage]!.isGranted);
    box.write('manage_storage_permission',
        statuses[Permission.manageExternalStorage]!.isGranted);

    // 🔹 Cek apakah izin diberikan
    if (!statuses[Permission.location]!.isGranted) {}
    if (!statuses[Permission.storage]!.isGranted) {}
  }

  /// 🔹 Mengecek apakah izin lokasi sudah diberikan
  bool isLocationGranted() {
    return box.read('location_permission') ?? false;
  }

  /// 🔹 Mengecek apakah izin penyimpanan sudah diberikan
  bool isStorageGranted() {
    return box.read('storage_permission') ?? false;
  }

  /// 🔹 Ambil lokasi terbaru (dengan Geolocator 13.0.3)
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
