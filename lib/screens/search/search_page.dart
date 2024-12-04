import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/main.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Add left padding
                  child: IconButton(
                    icon: Icon(
                      Icons.fastfood,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      // TODO: Add food search action
                    },
                  ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontally Scrollable Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...[
                    'Rice', 'Noodles', 'Meatball', 'Soto', 'Snacks', 'Sweets',
                    'Beverages', 'Indonesian', 'Japanese', 'Asian', 'Western'
                  ].map((category) => Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Chip(
                          label: Text(
                            category,
                            style: TextStyle(fontSize: 12.0),
                          ),
                          backgroundColor: Colors.orange[100],
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Recent Searches Section
            Text(
              'Recent searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Nasi Goreng'),
                  onTap: () {
                    // TODO: Handle recent search tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Mie Ayam'),
                  onTap: () {
                    // TODO: Handle recent search tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Seblak'),
                  onTap: () {
                    // TODO: Handle recent search tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('nasi alo'),
                  onTap: () {
                    // TODO: Handle recent search tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('ayam kremes ainah'),
                  onTap: () {
                    // TODO: Handle recent search tap
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Based on Your Previous Choices Section
            Text(
              'Based on your previous choices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Resto Card Placeholder',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}