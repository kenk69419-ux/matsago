import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isTesting = false;
  String? _testMessage;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final url = await StorageService.getBaseUrl();
    _urlController.text = url;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _isTesting = true;
      _testMessage = null;
    });

    try {
      final cleanUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
      // Coba akses endpoint verify test
      final response = await http
          .get(Uri.parse('$cleanUrl/api/siswa/verify/test'))
          .timeout(const Duration(seconds: 5));

      setState(() {
        _isTesting = false;
        // Status 404 dari verify test artinya server online dan merespon API!
        if (response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 400) {
          _testSuccess = true;
          _testMessage = 'Server berhasil terhubung!';
        } else {
          _testSuccess = false;
          _testMessage = 'Server merespon dengan status: ${response.statusCode}';
        }
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testSuccess = false;
        _testMessage = 'Gagal terhubung ke server ($e)';
      });
    }
  }

  Future<void> _saveSettings() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    await StorageService.setBaseUrl(url);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alamat server berhasil disimpan'),
        backgroundColor: Color(0xFF059669),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alamat Server Web Amalin',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Masukkan URL website sistem Amalin Anda (contoh: https://amalin.sekolah.sch.id atau http://192.168.1.10/amalin saat uji coba di jaringan lokal)',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'https://sekolah.com/amalin',
                      prefixIcon: const Icon(Icons.link, color: Color(0xFF1E3A8A)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _isTesting ? null : _testConnection,
                        icon: _isTesting
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.wifi_find, size: 18),
                        label: const Text('Tes Koneksi'),
                      ),
                    ],
                  ),
                  if (_testMessage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _testSuccess ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _testMessage!,
                        style: TextStyle(
                          color: _testSuccess ? const Color(0xFF065F46) : const Color(0xFFDC2626),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Simpan Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Color(0xFF4B5563)),
                      SizedBox(width: 8),
                      Text(
                        'Informasi Layanan OneSignal',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App ID: ${NotificationService.oneSignalAppId}',
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Layanan notifikasi push aktif secara gratis melalui server OneSignal.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
