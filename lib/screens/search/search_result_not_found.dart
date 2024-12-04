import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/main.dart';

class NoResultPage extends StatelessWidget {
  final String searchQuery = 'food';

  // NoResultPage({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.fastfood,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // TODO: Add food search action
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.restaurant,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // TODO: Add restaurant search action
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search restaurants or food',
                      hintStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // TODO: Add clear text action
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/hungry.png',
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'No Results Found for $searchQuery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}