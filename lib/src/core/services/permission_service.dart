import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';

class PermissionService {
  final box = GetStorage();

  /// 🔹 Meminta izin lokasi & media (gambar)
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = {};

    if (Platform.isAndroid) {
      // 🔸 Android 13 ke atas
      if (await Permission.photos.isGranted == false &&
          await Permission.photos.isPermanentlyDenied == false) {
        statuses[Permission.photos] = await Permission.photos.request();
      }

      // 🔸 Android < 13
      statuses.addAll(await [
        Permission.location,
        Permission.storage,
      ].request());
    } else {
      // 🔸 iOS
      statuses.addAll(await [
        Permission.location,
        Permission.photos,
      ].request());
    }

    // 🔥 Simpan status izin di GetStorage
    box.write('location_permission',
        statuses[Permission.location]?.isGranted ?? false);
    box.write(
        'storage_permission', statuses[Permission.storage]?.isGranted ?? false);
    box.write(
        'photos_permission', statuses[Permission.photos]?.isGranted ?? false);
  }

  bool isLocationGranted() {
    return box.read('location_permission') ?? false;
  }

  bool isStorageGranted() {
    return box.read('storage_permission') ?? false;
  }

  bool isPhotosGranted() {
    return box.read('photos_permission') ?? false;
  }

  /// 🔹 Ambil lokasi terbaru
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
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
