import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../models/student.dart';
import 'storage_service.dart';

class NotificationService {
  // OneSignal App ID sesuai yang ada di konfigurasi .env backend Amalin
  static const String oneSignalAppId = '9509cc88-c9e7-4951-a116-84fb3be217dc';

  static ValueNotifier<int> notificationTrigger = ValueNotifier<int>(0);

  static Future<void> initialize() async {
    // 1. Enable OneSignal debug logs (opsional saat development)
    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    }

    // 2. Inisialisasi OneSignal dengan App ID
    OneSignal.initialize(oneSignalAppId);

    // 3. Minta izin notifikasi (Wajib untuk Android 13+)
    await OneSignal.Notifications.requestPermission(true);

    // 4. Tangani saat notifikasi masuk ketika aplikasi sedang dibuka (Foreground)
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notif = event.notification;
      _saveReceivedNotification(
        notif.notificationId,
        notif.title ?? 'Laporan Absensi Siswa',
        notif.body ?? '',
      );
      // Biarkan notifikasi tetap muncul di status bar HP
      event.notification.display();
    });

    // 5. Tangani saat notifikasi di-klik oleh pengguna
    OneSignal.Notifications.addClickListener((event) {
      final notif = event.notification;
      _saveReceivedNotification(
        notif.notificationId,
        notif.title ?? 'Laporan Absensi Siswa',
        notif.body ?? '',
      );
    });
  }

  static Future<void> _saveReceivedNotification(
      String id, String title, String body) async {
    final history = AttendanceHistory(
      id: id,
      title: title,
      body: body,
      receivedAt: DateTime.now(),
    );
    await StorageService.addHistory(history);
    notificationTrigger.value++;
  }

  /// Daftarkan NIS anak ke OneSignal Device Tag
  static Future<void> registerStudentNis(String nis) async {
    try {
      // Menambahkan Tag 'nis' ke OneSignal user saat ini
      // Di backend Amalin Scan.php: filter tag 'nis' = $nis
      await OneSignal.User.addTagWithKey('nis', nis);
      debugPrint('[OneSignal] Sukses menambahkan tag nis: $nis');
    } catch (e) {
      debugPrint('[OneSignal] Gagal menambahkan tag nis: $e');
    }
  }

  /// Hapus tag jika orang tua keluar / mengganti NIS anak
  static Future<void> unregisterStudentNis() async {
    try {
      await OneSignal.User.removeTag('nis');
      debugPrint('[OneSignal] Sukses menghapus tag nis');
    } catch (e) {
      debugPrint('[OneSignal] Gagal menghapus tag nis: $e');
    }
  }
}
