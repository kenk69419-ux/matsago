import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import 'storage_service.dart';

class ApiService {
  static Future<Map<String, dynamic>> verifyStudent(String nis) async {
    try {
      final baseUrl = await StorageService.getBaseUrl();
      final url = Uri.parse('$baseUrl/api/siswa/verify/$nis');

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['data'] != null) {
        return {
          'success': true,
          'student': Student.fromJson(data['data']),
          'message': data['message'] ?? 'Siswa berhasil diverifikasi',
        };
      } else {
        return {
          'success': false,
          'message': data['messages']?['error'] ??
              data['message'] ??
              'NIS tidak ditemukan di sistem.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server ($e). Pastikan URL server benar dan internet aktif.',
      };
    }
  }
}
