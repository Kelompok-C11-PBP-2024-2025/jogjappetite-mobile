import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/screens/search/search_bar.dart';
import 'package:jogjappetite_mobile/screens/search/search_functions.dart';

class SearchResultFood extends StatefulWidget {
  final List<dynamic> data;

  SearchResultFood({required this.data});

  @override
  _SearchResultFoodState createState() => _SearchResultFoodState();
}

class _SearchResultFoodState extends State<SearchResultFood> {
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
          final menu = widget.data[index];
          return ListTile(
            title: Text(menu['nama_menu']),
            subtitle: Text(menu['description']),
            trailing: Text('\$${menu['price']}'),
          );
        },
      ),
    );
  }
}