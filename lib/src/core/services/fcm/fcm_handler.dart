import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class FCMHandler {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Minta izin (iOS)
    await messaging.requestPermission();

    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      final notif = message.notification;
      if (notif != null) {
        NotificationService.show(notif);
      }
    });

    // Background → klik notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // TODO: Navigasi ke halaman tertentu
      print("👉 Diklik dari background: ${message.data}");
    });

    // Terminated → app dibuka dari notifikasi
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      print("🚪 Dibuka dari terminated: ${initialMessage.data}");
      // TODO: Navigasi ke halaman tertentu
    }
  }
}
