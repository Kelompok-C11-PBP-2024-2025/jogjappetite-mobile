import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/search/search_functions.dart';
import 'package:jogjappetite_mobile/screens/search/search_bar.dart';
import 'package:jogjappetite_mobile/models/search_history.dart';
import 'package:jogjappetite_mobile/screens/search/search_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // For JSON encoding/decoding

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  Future<List<SearchHistory>> fetchHistory(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/search/json/');
    var data = response;
    List<SearchHistory> listHistory = [];
    for (var d in data) {
      if (d != null) {
        listHistory.add(SearchHistory.fromJson(d));
      }
    }
    return listHistory;
  }

  Future<void> deleteSearchHistory(int historyId, CookieRequest request) async {
    await request.post(
      'http://127.0.0.1:8000/search/delete-history/$historyId/',
      {},
    );
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppBar(
        searchController: _searchController,
        onSaveSearchHistory: (query, req) => saveSearchHistory(query, req),
        onSearchFood: (query, req, ctx) => searchFood(query, req, ctx),
        onSearchRestaurant: (query, req, ctx) => searchRestaurant(query, req, ctx),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Chips (unchanged)
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
                future: fetchHistory(request),
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
                      itemBuilder: (context, index) {
                        final history = snapshot.data![index];
                        return ListTile(
                          leading: Icon(Icons.search),
                          title: Text(history.fields.query),
                          onTap: () {
                            setState(() {
                              _searchController.text = history.fields.query;
                            });
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () async {
                              await deleteSearchHistory(history.pk, request);
                              setState(() {});
                            },
                          ),
                        );
                      },
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