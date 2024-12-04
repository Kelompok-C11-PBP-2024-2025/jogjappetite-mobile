import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/search/search_page.dart';
import 'package:jogjappetite_mobile/widgets/navbar.dart';
import 'package:jogjappetite_mobile/screens/ratings/ratings_main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogjappetite"),
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Welcome to Jogjappetite!')),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
