import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';
import 'screens/login_nis_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale formatting bahasa Indonesia
  try {
    await initializeDateFormatting('id_ID', null);
  } catch (e) {
    debugPrint('Gagal inisialisasi date formatting: $e');
  }

  // 1. Inisialisasi OneSignal Notifikasi
  await NotificationService.initialize();

  // 2. Cek apakah pengguna sudah menghubungkan NIS anak sebelumnya
  final activeStudent = await StorageService.getActiveStudent();

  runApp(AmalinApp(hasActiveStudent: activeStudent != null));
}

class AmalinApp extends StatelessWidget {
  final bool hasActiveStudent;

  const AmalinApp({super.key, required this.hasActiveStudent});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amalin - MTs Ma\'arif Kaligowong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
        ),
        fontFamily: 'Roboto',
      ),
      home: hasActiveStudent ? const HomeScreen() : const LoginNisScreen(),
    );
  }
}
