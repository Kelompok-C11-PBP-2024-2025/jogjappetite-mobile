import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/widgets/navbar.dart';
import 'package:jogjappetite_mobile/screens/explore/explore_page.dart';
import 'package:jogjappetite_mobile/screens/search/search_page.dart';
import 'package:jogjappetite_mobile/screens/ratings/ratings_main_page.dart';
import 'package:jogjappetite_mobile/screens/restaurant/restaurant_page.dart';
import 'package:jogjappetite_mobile/screens/favorite/favorite_page.dart';
import 'package:jogjappetite_mobile/screens/authentication/login.dart';
import 'package:jogjappetite_mobile/screens/authentication/userprofilepage.dart';


class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Index navbar

  // Halaman yang ditampilkan berdasarkan index
  final List<Widget> _pages = [
    ExplorePage(),
    SearchPage(),
    FavoritePage(),
    RatingsMainPage(),
    RestaurantPage(),
  ];

  // Tambahkan widget profile
  Widget _buildProfilePage() {
    bool isLoggedIn = true; // Logic login diganti nanti
    return isLoggedIn ? UserProfilePage() : LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 5 ? _buildProfilePage() : _pages[_currentIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
