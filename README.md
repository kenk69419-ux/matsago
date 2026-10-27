# Aplikasi Android Orang Tua (Amalin Absensi)

Aplikasi Android untuk Orang Tua Siswa yang menerima **Push Notification Real-time** saat anak melakukan absensi Masuk dan Pulang di sekolah menggunakan **OneSignal (100% Gratis)**.

---

## 📱 Fitur Utama Aplikasi

1. **Hubungkan NIS Anak**:
   - Orang tua cukup memasukkan NIS anak sekali saja.
   - Aplikasi otomatis mengecek data ke server Amalin (`/api/siswa/verify/{nis}`) dan menampilkan Nama serta Kelas siswa.
2. **Push Notification OneSignal Real-time**:
   - Device orang tua otomatis ditandai dengan Tag `nis`.
   - Ketika anak melakukan scan QR absen di sekolah, notifikasi langsung berdering di HP orang tua.
3. **Riwayat Notifikasi**:
   - Catatan absen masuk & pulang otomatis tersimpan di HP agar orang tua bisa mengecek kembali riwayat kehadiran.
4. **Pengaturan URL Server**:
   - URL sistem sekolah dapat disesuaikan (misal: `https://sekolah.sch.id` atau IP lokal Laragon untuk uji coba).

---

## 🛠️ Persyaratan Build APK (100% Gratis)

1. **Flutter SDK** (Versi 3.x ke atas) - Download gratis di [flutter.dev](https://flutter.dev)
2. **Android SDK / Android Studio** (Hanya untuk build tools `adb` & `gradle`) atau **VS Code**

---

## 🚀 Cara Build File APK

### Langkah 1: Buka Terminal di Folder Aplikasi
Masuk ke folder aplikasi ini:
```bash
cd amalin_ortu_app
```

### Langkah 2: Ambil Dependencies (Packages)
```bash
flutter pub get
```

### Langkah 3: Build APK Release
Jalankan perintah berikut untuk membuat file `.apk` siap pakai:
```bash
flutter build apk --release
```

File APK akan selesai dibuat di lokasi:
📁 `amalin_ortu_app/build/app/outputs/flutter-apk/app-release.apk`

File `app-release.apk` ini bisa langsung Anda bagikan ke orang tua melalui WhatsApp atau link download sekolah untuk di-install di HP Android mereka!

---

## ⚙️ Konfigurasi OneSignal

App ID OneSignal Anda sudah otomatis terpasang sesuai file `.env` sistem Amalin:
- **App ID:** `9509cc88-c9e7-4951-a116-84fb3be217dc`
- File konfigurasi: `lib/services/notification_service.dart`

---

## 🧪 Cara Uji Coba

1. Buka aplikasi di HP orang tua.
2. Pada menu **Pengaturan (Ikon Gir)**, masukkan alamat web Amalin Anda (misal `http://192.168.1.xxx/amalin` atau domain website).
3. Masukkan NIS anak dan klik **Cek Data Siswa**.
4. Klik **Aktifkan Notifikasi untuk Siswa Ini**.
5. Buka sistem web Amalin di browser, buka menu Scan QR, lalu scan QR siswa tersebut.
6. Notifikasi absen akan langsung muncul di HP orang tua!
