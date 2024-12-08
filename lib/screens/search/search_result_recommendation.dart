import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/screens/search/search_bar.dart';
import 'package:jogjappetite_mobile/screens/search/search_functions.dart';

class SearchResultRecommendation extends StatefulWidget {
  final List<dynamic> data;

  SearchResultRecommendation({required this.data});

  @override
  _SearchResultRecommendationState createState() => _SearchResultRecommendationState();
}

class _SearchResultRecommendationState extends State<SearchResultRecommendation> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: SearchAppBar(
        searchController: _searchController,
        onSaveSearchHistory: saveSearchHistory,
        onSearchFood: searchFood,
        onSearchRestaurant: searchRestaurant,
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          // Adjust the way you display the item based on whether it's a menu or restaurant
          return ListTile(
            title: Text(item['nama_menu'] ?? item['nama_restoran'] ?? 'Unknown'),
            // Include other fields as needed
          );
        },
      ),
    );
  }
}