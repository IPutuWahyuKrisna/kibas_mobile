// 🟢 Import GetIt
import 'package:get_storage/get_storage.dart';
import '../../features/auth/data/models/user_model.dart';

class UserLocalStorageService {
  // 🟢 Ambil instance GetStorage dari GetIt
  final box = GetStorage();

  /// 🟢 Menyimpan data user ke GetStorage
  Future<void> saveUser(UserModel user) async {
    try {
      final userData = user.toJson();
      print("berhasil menyimpan user");

      await box.write('user', userData);
    } catch (e) {
      print("Error saat menyimpan user: $e"); // Jangan kosongkan catch
    }
  }

  /// 🟢 Mengambil data user dari GetStorage
  UserModel? getUser() {
    try {
      final userData = box.read('user');
      

      if (userData != null) {
        
        return UserModel.fromJson(Map<String, dynamic>.from(userData));
        
      }
    } catch (e) {
      print("Error saat membaca user: $e"); // Jangan kosongkan catch
    }
    return null;
  }

  /// 🟢 Menghapus data user dari GetStorage (logout)
  Future<void> clearUser() async {
    try {
      await box.remove('user');
      // ignore: empty_catches
    } catch (e) {}
  }
}
