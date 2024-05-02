import 'dart:convert'; // mengimpor library untuk menggunakan jsonDecode

void main() {
  // JSON transkrip mahasiswa
  String jsonTranskrip = '''
{
  "mahasiswa": {
    "nama": "Nurul Izzah",
    "nim": "22082010008",
    "mata_kuliah": [
      {
        "nama": "Bela Negara",
        "sks": 3,
        "nilai": 4
      },
      {
        "nama": "Pemrograman Dekstop",
        "sks": 3,
        "nilai": 3.75
      },
      {
        "nama": "Analisis Sistem Informasi",
        "sks": 3,
        "nilai": 3.75
      },
      {
        "nama": "Administrasi Basis Data",
        "sks": 3,
        "nilai": 4
      },
      {
        "nama": "Metodologi Penelitian",
        "sks": 2,
        "nilai": 4
      },
      {
        "nama": "Desain Manajemen Jaringan",
        "sks": 3,
        "nilai": 4
      },
      {
        "nama": "Tata Kelola Teknologi Informasi",
        "sks": 3,
        "nilai": 3.50
      },
      {
        "nama": "Interaksi Manusia Komputer",
        "sks": 3,
        "nilai": 4
      }
    ]
  }
}''';

  // mengubah data ke JSON
  Map<String, dynamic> transkrip =
      jsonDecode(jsonTranskrip); // mengubah data string JSON ke dalam Map

  List<dynamic> mataKuliah = transkrip['mahasiswa']
      ['mata_kuliah']; // mengambil data daftar mata kuliah
  double totalNilai = 0; // inisialisasi total nilai
  int totalSKS = 0; // inisialisasi total SKS
  for (var matkul in mataKuliah) {
    // looping untuk setiap mata kuliah
    int sks = matkul['sks']; // mengambil data SKS mata kuliah
    totalSKS += sks; // tambahkan SKS ke total SKS
    totalNilai += matkul['nilai'] * sks; // tambahkan nilai * sks ke total nilai
  }

  double ipk = totalNilai / totalSKS; // rumus hitung IPK
  print('IPK: ${ipk.toStringAsFixed(3)}'); // cetak IPK
}
