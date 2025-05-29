import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kibas_mobile/src/config/routes/router.dart';
import 'notification_service.dart';

class FCMHandler {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _requestNotificationPermission();
    _setupForegroundHandler();
    _setupBackgroundHandler();
    await _handleTerminatedMessage();
  }

  static Future<void> _requestNotificationPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final data = message.data;
      print("ini notifikasinya $notification");
      print("ini notifikasinya $data");

      if (notification != null) {
        NotificationService.show(notification);
        _handleNavigation(data);
      }
    });
  }

  static void _setupBackgroundHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("ini notifikasinya ${message.data}");
      _handleNavigation(message.data);
    });
  }

  static Future<void> _handleTerminatedMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print("ini notifikasinya ${initialMessage.data}");
      _handleNavigation(initialMessage.data);
    }
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    final type = data['type'];
    final router = AppRouter.router;

    switch (type) {
      case 'baca-meter':
        router.push('/dashboard_user/get_meter');
        break;
      case 'tagihan':
        router.push('/dashboard_user/rekening');
        break;
      case 'pengumuman':
        router.push('/dashboard_user/detail-pengumuman');
        break;
      case 'pengaduan':
        router.push('/dashboard_user/list_complaint_users');
        break;
      default:
        router.push('/dashboard_user');
    }
  }
}
