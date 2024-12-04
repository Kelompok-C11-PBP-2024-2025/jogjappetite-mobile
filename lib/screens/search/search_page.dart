import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/main.dart';
import 'package:jogjappetite_mobile/models/search_history.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  // List<SearchHistory> _recentSearches = [];

  // @override
  // void initState() {
  //   super.initState();
  //   fetchHistory().then((history) {
  //     setState(() {
  //       _recentSearches = history;
  //     });
  //   });
  // }

  Future<List<SearchHistory>> fetchHistory(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/search/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object SearchHistory
    List<SearchHistory> listHistory = [];
    for (var d in data) {
      if (d != null) {
        listHistory.add(SearchHistory.fromJson(d));
      }
    }
    return listHistory;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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

            Text(
              'Recent searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<SearchHistory>>(
                future: fetchHistory(request), // Fetch the recent searches
                builder: (context, AsyncSnapshot<List<SearchHistory>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No recent searches'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Icon(Icons.search),
                        title: Text(snapshot.data![index].fields.query),
                        onTap: () {
                          setState(() {
                            _searchController.text = snapshot.data![index].fields.query;
                          });
                        },
                      ),
                    );
                  }
                },
              ),
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