import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';

class StorageService {
  static const String _keyBaseUrl = 'base_url';
  static const String _keyStudent = 'active_student';
  static const String _keyHistory = 'attendance_history';

  // Default server URL - sesuaikan dengan domain atau IP server Amalin
  static const String defaultBaseUrl = 'http://10.0.2.2/amalin'; // 10.0.2.2 untuk emulator, ganti dengan domain/IP jika di HP asli

  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBaseUrl) ?? defaultBaseUrl;
  }

  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    // Hilangkan trailing slash jika ada
    final cleanUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    await prefs.setString(_keyBaseUrl, cleanUrl);
  }

  static Future<Student?> getActiveStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyStudent);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      return Student.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveActiveStudent(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStudent, jsonEncode(student.toJson()));
  }

  static Future<void> clearActiveStudent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyStudent);
  }

  static Future<List<AttendanceHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyHistory);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => AttendanceHistory.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addHistory(AttendanceHistory item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getHistory();
    // Tambah item paling atas
    list.insert(0, item);
    // Batasi maksimum 100 riwayat tersimpan
    if (list.length > 100) {
      list.removeRange(100, list.length);
    }
    await prefs.setString(
      _keyHistory,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }
}
