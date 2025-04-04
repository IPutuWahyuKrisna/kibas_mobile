import '../../domain/entities/log_out.dart';

class LogoutModel extends Logout {
  LogoutModel({
    required super.message,
  });

  // 🟢 Factory untuk mapping dari JSON ke LogoutModel
  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      message: json['message'] ?? 'Logout successful',
    );
  }

  // 🟢 Mapping dari LogoutModel ke JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
