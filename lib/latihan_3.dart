import 'package:flutter/material.dart'; // mengimpor package flutter/material.dart untuk menggunakan Flutter UI framework
import 'package:http/http.dart'
    as http; // mengimpor package http.dart dari http untuk melakukan HTTP requests
import 'dart:convert'; // mengimpor package dart:convert untuk mengonversi JSON

class Universitas {
  // membuat class Universitas untuk menyimpan informasi universitas
  String nama; // variabel untuk menyimpan nama universitas
  List<String> domains; // variabel untuk menyimpan domain universitas
  List<String> webPages; // variabel untuk menyimpan halaman web universitas

  Universitas(
      {required this.nama,
      required this.domains,
      required this.webPages}); // constructor untuk class Universitas

  factory Universitas.fromJson(Map<String, dynamic> json) {
    // factory method untuk membuat objek Universitas dari JSON
    return Universitas(
      nama: json['name'],
      domains: List<String>.from(json['domains']),
      webPages: List<String>.from(json['web_pages']),
    );
  }
}

class DaftarUniversitas {
  // membuat class DaftarUniversitas untuk menyimpan daftar universitas
  List<Universitas> daftar =
      <Universitas>[]; // variabel untuk menyimpan daftar universitas

  DaftarUniversitas(List<dynamic> json) {
    // constructor untuk class DaftarUniversitas
    for (var val in json) {
      daftar.add(
          Universitas.fromJson(val)); // menambahkan universitas ke dalam daftar
    }
  }

  factory DaftarUniversitas.fromJson(List<dynamic> json) {
    // factory method untuk membuat objek DaftarUniversitas dari JSON
    return DaftarUniversitas(json);
  }
}

void main() {
  runApp(MyApp()); // menjalankan aplikasi Flutter
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // membuat dan mengembalikan state untuk aplikasi
  }
}

class MyAppState extends State<MyApp> {
  late Future<DaftarUniversitas>
      futureDaftarUniversitas; // future untuk menampung daftar universitas dari API

  Future<DaftarUniversitas> fetchData() async {
    // method untuk melakukan fetch data dari API
    final response = await http.get(// melakukan HTTP GET request ke API
        Uri.parse("http://universities.hipolabs.com/search?country=Indonesia"));

    if (response.statusCode == 200) {
      // jika request berhasil
      return DaftarUniversitas.fromJson(jsonDecode(
          response.body)); // mengembalikan daftar universitas dari JSON
    } else {
      // jika request gagal
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    // method untuk inisialisasi state
    super.initState();
    futureDaftarUniversitas = fetchData(); // memuat data daftar universitas
  }

  @override
  Widget build(BuildContext context) {
    // method untuk membangun UI
    return MaterialApp(
      title: 'Daftar Universitas Indonesia',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Universitas Indonesia'),
        ),
        body: Center(
          child: FutureBuilder<DaftarUniversitas>(
            future: futureDaftarUniversitas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // jika data sudah tersedia
                return ListView.builder(
                  // membuat list view untuk menampilkan daftar universitas
                  itemCount: snapshot.data!.daftar.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.daftar[index]
                          .nama), // menampilkan nama universitas
                      subtitle: Column(
                        // menampilkan domain dan web pages universitas
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Domains: ${snapshot.data!.daftar[index].domains.join(', ')}'),
                          Text(
                              'Web Pages: ${snapshot.data!.daftar[index].webPages.join(', ')}'),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // jika terjadi error
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator(); // default: menampilkan loading indicator
            },
          ),
        ),
      ),
    );
  }
}
