import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jogjappetite_mobile/models/favorite.dart';
import 'package:jogjappetite_mobile/screens/favorite/favorite_add_card.dart';

class FavoriteAddPage extends StatefulWidget {
  @override
  _FavoriteAddPageState createState() => _FavoriteAddPageState();
}

class _FavoriteAddPageState extends State<FavoriteAddPage> {
  late Future<List<Restaurant>> _allRestaurants;

  Future<List<Restaurant>> fetchAllRestaurants() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/favorite/all-restaurants/flutter/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  @override
  void initState() {
    super.initState();
    _allRestaurants = fetchAllRestaurants();
  }

  void addRestaurant(String note) {
    print('Adding restaurant with note: $note');
    // Implementasi logika untuk menyimpan data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Restaurants'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Restaurant>>(
          future: _allRestaurants,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final restaurants = snapshot.data;

              if (restaurants == null || restaurants.isEmpty) {
                return Center(
                  child: Text(
                    'No Restaurants Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return FavoriteAddCard(
                      favorite: Favorite(
                        id: restaurant.id,
                        user: "current_user",
                        restaurant: restaurant,
                        notes: "",
                        createdAt: DateTime.now(),
                      ),
                      onAdd: (note) => addRestaurant(note), // Pastikan fungsi ini benar
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
