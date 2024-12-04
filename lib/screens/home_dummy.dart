import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/widgets/navbar.dart';
import 'package:jogjappetite_mobile/screens/ratings/ratings_main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Ubah ke page modul masing-masing
    const Center(child: Text('Explore Page - Coming Soon')),
    const Center(child: Text('Search Page - Coming Soon')),
    const Center(child: Text('Favorites Page - Coming Soon')),
    const RatingsPage(),
    const Center(child: Text('Restaurants Page - Coming Soon')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogjappetite"),
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
