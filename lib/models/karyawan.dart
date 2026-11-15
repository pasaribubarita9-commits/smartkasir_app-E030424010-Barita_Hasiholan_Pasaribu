class Karyawan {
  final int? id;
  final String namaKaryawan;
  final String pin;
  final String peran;
  final String? createdAt;

  Karyawan({
    this.id,
    required this.namaKaryawan,
    required this.pin,
    required this.peran,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_karyawan': namaKaryawan,
      'pin': pin,
      'peran': peran,
      'created_at': createdAt,
    };
  }

  factory Karyawan.fromMap(Map<String, dynamic> map) {
    return Karyawan(
      id: map['id'] as int?,
      namaKaryawan: map['nama_karyawan'] as String,
      pin: map['pin'] as String,
      peran: map['peran'] as String,
      createdAt: map['created_at'] as String?,
    );
  }
}
