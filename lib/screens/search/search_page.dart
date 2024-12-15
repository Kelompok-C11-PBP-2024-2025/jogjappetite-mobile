import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/search/search_functions.dart';
import 'package:jogjappetite_mobile/screens/search/search_bar.dart';
import 'package:jogjappetite_mobile/models/search_history.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

import 'package:jogjappetite_mobile/models/ratings.dart'; // This contains the Restaurant model
import 'package:jogjappetite_mobile/screens/ratings/restaurant_card.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_ratings_page.dart'; // Page restaurant yang akan muncul setelah di klik


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  // User type (not logged-in, customer or restaurant owner)
  String? userType;

  // Restaurants data
  List<Restaurant>? allRestaurants;
  bool isRestaurantsLoading = true;
  String? restaurantsError;

  @override
  void initState() {
    super.initState();
    _getUserType(); // Fetch userType when the widget initializes
    fetchRestaurants();
  }

  Future<void> _getUserType() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/auth/get-user-type/'); // Replace with your server address

      final data = json.decode(response.body);

      setState(() {
        userType = data['user_type'];
      });
    } catch (e) {
      print('Error getting user type: $e');
    }
  }

  Future<List<SearchHistory>> fetchHistory(CookieRequest request) async {
    try{
      final response = await request.get('http://127.0.0.1:8000/search/json/');

      final data = json.decode(response.body);
      
      List<SearchHistory> listHistory = [];
      for (var d in data) {
        if (d != null) {
          listHistory.add(SearchHistory.fromJson(d));
        }
      }
      return listHistory;
    } catch (e) {
      print('Error fetching search history: $e');
      return [];
    }
  }

  Future<void> deleteSearchHistory(int historyId, CookieRequest request) async {
    await request.post(
      'http://127.0.0.1:8000/search/delete-history/$historyId/',
      {},
    );
  }

  Future<void> fetchRestaurants() async {
    setState(() {
      isRestaurantsLoading = true;
      restaurantsError = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/search/get-random-restaurant-flutter/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allRestaurants = data.map((json) => Restaurant.fromJson(json)).toList();
          isRestaurantsLoading = false;
        });
      } else {
        setState(() {
          restaurantsError = 'Server error: ${response.statusCode}';
          isRestaurantsLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        restaurantsError = 'Network error: $e';
        isRestaurantsLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: SearchAppBar(
      searchController: _searchController,
      onSaveSearchHistory: (query, req) {
        if (userType != null) {
          saveSearchHistory(query, req);
        }
      },
      onSearchFood: (query, context) => searchFood(query, context),
      onSearchRestaurant: (query, context) => searchRestaurant(query, context),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // **Category Chips**
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(height: 20),

        // **Recent Searches**
        if (userType != null) ...[
          Text(
            'Recent searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<SearchHistory>>(
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
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
          SizedBox(height: 20),
        ] else ...[
          Center(
            child: Text('Log in to see your recent searches.'),
          ),
          SizedBox(height: 20),
        ],

        // **Recommended Restaurants Section**
        Text(
          'Try Out These Restaurants',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        if (isRestaurantsLoading)
          Center(child: CircularProgressIndicator())
        else if (restaurantsError != null)
          Center(child: Text(restaurantsError!))
        else if (allRestaurants != null && allRestaurants!.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust as needed
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85, // Adjust for proportions
            ),
            itemCount: allRestaurants!.length,
            itemBuilder: (context, index) {
              final restaurant = allRestaurants![index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantRatingsPage(
                        restaurantId: restaurant.id,
                        restaurantName: restaurant.namaRestoran,
                      ),
                    ),
                  );
                },
              );
            },
          )
        else
          Center(child: Text('No restaurants found.')),
        SizedBox(height: 20),
      ],
    ),
  );
}}