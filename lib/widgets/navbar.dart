import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/ratings/ratings_main.dart';
import 'package:jogjappetite_mobile/screens/search/search_page.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const BottomNavbar({
    super.key,
    this.currentIndex = 0,
  });

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
      page: const RatingsPage(),
    ),
    NavigationItem(
      label: 'Restaurants',
      icon: Icons.restaurant_outlined,
      activeIcon: Icons.restaurant,
      page: const Center(child: Text('Restaurants Page - Coming Soon')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              items.length,
              (index) => InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text("Jogjappetite"),
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                        ),
                        body: items[index].page,
                        bottomNavigationBar: BottomNavbar(
                          currentIndex: index,
                        ),
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
                        currentIndex == index
                            ? items[index].activeIcon
                            : items[index].icon,
                        color: currentIndex == index ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: currentIndex == index
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color:
                              currentIndex == index ? Colors.red : Colors.grey,
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
