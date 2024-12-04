import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/authentication/menu.dart';
import 'package:jogjappetite_mobile/screens/ratings/ratings_main.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const BottomNavbar({
    super.key,
    required this.onItemSelected,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final List<NavigationItem> items = [
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
        page: const Center(child: Text('Search Page - Coming Soon')),
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
              (index) => _buildNavItem(
                context: context,
                item: items[index],
                isSelected: currentIndex == index,
                index: index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavigationItem item,
    required bool isSelected,
    required int index,
  }) {
    return InkWell(
      onTap: () => onItemSelected(index),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? Colors.red : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.red : Colors.grey,
              ),
            ),
          ],
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
