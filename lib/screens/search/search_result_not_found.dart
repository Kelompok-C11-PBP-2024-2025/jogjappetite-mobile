import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/screens/search/search_bar.dart';
import 'package:jogjappetite_mobile/screens/search/search_functions.dart';

class SearchResultNotFound extends StatefulWidget {
  final String query;

  SearchResultNotFound({required this.query});
  
  @override
  _SearchResultNotFoundState createState() => _SearchResultNotFoundState();
}

class _SearchResultNotFoundState extends State<SearchResultNotFound> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    _searchController.text = widget.query;
    
    return Scaffold(
      appBar: SearchAppBar(
        searchController: _searchController,
        onSaveSearchHistory: saveSearchHistory,
        onSearchFood: searchFood,
        onSearchRestaurant: searchRestaurant,
      ),
      body: Center(
        child: Text(
          'No results found for "${widget.query}"',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}