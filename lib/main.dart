import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/authentication/login.dart';
import 'package:jogjappetite_mobile/screens/explore/explore_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/screens/main_page.dart';

// DUMMY PAGE
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        // title: 'Jogjappetite',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red, // Ubah menjadi warna utama Jogjappetite
          ).copyWith(
            primary: Colors.red[700], // Warna merah utama
            secondary: Colors.orangeAccent, // Warna sekunder
          ),
          scaffoldBackgroundColor:
              const Color(0xFFFFF8F0), // Latar belakang soft peach
          cardColor: const Color(0xFFFFFFFF), // Warna kartu
        ),
        home: MainPage(),
      ),
    );
  }
}
