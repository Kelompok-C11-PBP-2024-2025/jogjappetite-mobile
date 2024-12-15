import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/authentication/login.dart';
import 'package:jogjappetite_mobile/screens/authentication/userprofilepage.dart';
import 'package:jogjappetite_mobile/screens/ratings/ratings_main_page.dart';
import 'package:jogjappetite_mobile/screens/restaurant/restaurant_page.dart';
import 'package:jogjappetite_mobile/screens/search/search_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;

  const BottomNavbar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  String? userType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Future<void> _getUserType() async {
    final request = context.read<CookieRequest>();
    try {
      final response =
          await request.get('http://127.0.0.1:8000/auth/get-user-type/');
      setState(() {
        userType = response['user_type'];
        isLoading = false;
      });
    } catch (e) {
      print('Error getting user type: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  static final List<NavigationItem> items = [
    NavigationItem(
      label: 'Explore',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      page: const Center(child: Text('Explore Page - Coming Soon')),
    ),
    NavigationItem(
      label: 'Search',
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      page: SearchPage(),
    ),
    NavigationItem(
      label: 'Favorites',
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      page: const Center(child: Text('Favorites Page - Coming Soon')),
    ),
    NavigationItem(
      label: 'Ratings',
      icon: Icons.star_outline,
      activeIcon: Icons.star,
      page: const RatingsMainPage(),
    ),
    NavigationItem(
      label: 'Restaurants',
      icon: Icons.restaurant_outlined,
      activeIcon: Icons.restaurant,
      page: const RestaurantPage()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Add profile item dynamically based on user type
    final allItems = [...items];
    allItems.add(
      NavigationItem(
        label: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        page: const LoginPage(), // This will be used for non-logged in users
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              allItems.length,
              (index) => InkWell(
                onTap: () {
                  // Special handling for profile tab
                  if (index == allItems.length - 1) {
                    if (userType == null) {
                      // If not logged in, go to login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      return;
                    }
                    // If logged in, go to profile page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: const UserProfilePage(),
                          bottomNavigationBar:
                              BottomNavbar(currentIndex: index),
                        ),
                      ),
                    );
                    return;
                  }

                  // Normal navigation for other tabs
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: allItems[index].page,
                        bottomNavigationBar: BottomNavbar(currentIndex: index),
                      ),
                    ),
                  );
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.currentIndex == index
                            ? allItems[index].activeIcon
                            : allItems[index].icon,
                        color: widget.currentIndex == index
                            ? Colors.red
                            : Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        allItems[index].label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: widget.currentIndex == index
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: widget.currentIndex == index
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });
}
