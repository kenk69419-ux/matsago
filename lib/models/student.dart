class Student {
  final String nis;
  final String namaSiswa;
  final String kelas;

  Student({
    required this.nis,
    required this.namaSiswa,
    required this.kelas,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      nis: json['nis']?.toString() ?? '',
      namaSiswa: json['nama_siswa']?.toString() ?? '',
      kelas: json['kelas']?.toString() ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_siswa': namaSiswa,
      'kelas': kelas,
    };
  }
}

class AttendanceHistory {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;

  AttendanceHistory({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
  });

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) {
    return AttendanceHistory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      receivedAt: DateTime.tryParse(json['received_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'received_at': receivedAt.toIso8601String(),
    };
  }
}
