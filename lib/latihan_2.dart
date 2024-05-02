import 'package:flutter/material.dart'; // mengimpor library flutter
import 'package:http/http.dart'
    as http; // mengimpor library http dengan alias http
import 'dart:convert'; // mengimpor library convert dari package dart

void main() {
  // fungsi utama yang dijalankan pertama kali
  runApp(const MyApp()); // menjalankan aplikasi flutter
}

// kelas untuk menampung data hasil pemanggilan API
class Activity {
  String aktivitas; // inisialisasi variabel untuk menampung aktivitas
  String jenis; // inisialisasi variabel untuk menampung jenis aktivitas

  Activity(
      {required this.aktivitas,
      required this.jenis}); // konstruktor untuk kelas Activity

  // method untuk mengubah data dari JSON ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // mengambil nilai activity dari JSON
      jenis: json['type'], // mengambil nilai type dari JSON
    );
  }
}

// kelas MyApp adalah StatefulWidget, yang berarti dapat berubah berdasarkan waktu dan interaksi pengguna
class MyApp extends StatefulWidget {
  const MyApp({super.key}); // konstruktor untuk kelas MyApp

  @override
  State<StatefulWidget> createState() {
    // method untuk membuat state dari MyApp
    return MyAppState(); // mengembalikan nilai MyAppState
  }
}

// kelas MyAppState adalah state dari MyApp
class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; // variabel untuk menampung hasil future activity

  //late Future<Activity>? futureActivity;
  String url =
      "https://www.boredapi.com/api/activity"; // URL untuk mengambil data dari API

  // method untuk inisialisasi futureActivity
  Future<Activity> init() async {
    return Activity(
        aktivitas: "",
        jenis: ""); // mengembalikan activity dengan nilai awal kosong
  }

  // method untuk mengambil data dari API
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // mengirimkan permintaan GET ke URL

    if (response.statusCode == 200) {
      // jika respon dari server adalah 200 (OK)
      // mengubah data JSON menjadi objek activity
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika respon tidak OK, maka keluar exception berikut
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    // method untuk inisialisasi state
    super.initState(); // memanggil initState dari kelas induk
    futureActivity = init(); // menginisialisasi futureActivity
  }

  @override
  Widget build(Object context) {
    // method untuk membangun tampilan aplikasi
    return MaterialApp(
        // widget MaterialApp sebagai root aplikasi
        home: Scaffold(
      // widget Scaffold sebagai kerangka aplikasi
      body: Center(
        // widget Center untuk membuat konten berada di tengah layar
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              // tombol untuk memuat aktivitas baru
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // memuat aktivitas baru
                });
              },
              child: const Text("Saya bosan ..."), // teks tombol
            ),
          ),
          FutureBuilder<Activity>(
            future:
                futureActivity, // future untuk membangun widget FutureBuilder
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // jika sudah ada data
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // menampilkan aktivitas
                      Text(
                          "Jenis: ${snapshot.data!.jenis}") // menampilkan jenis aktivitas
                    ]));
              } else if (snapshot.hasError) {
                // jika terjadi error
                return Text('${snapshot.error}'); // menampilkan pesan error
              }
              // default: menampilkan loading spinner
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
