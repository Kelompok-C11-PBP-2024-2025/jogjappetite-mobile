import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/screens/search/search_bar.dart';
import 'package:jogjappetite_mobile/screens/search/search_functions.dart';

class SearchResultResto extends StatefulWidget {
  final List<dynamic> data;

  SearchResultResto({required this.data});

  @override
  _SearchResultRestoState createState() => _SearchResultRestoState();
}

class _SearchResultRestoState extends State<SearchResultResto> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          final restaurant = widget.data[index];
          return ListTile(
            title: Text(restaurant['nama_restoran']),
            subtitle: Text(restaurant['lokasi']),
            trailing: Text(restaurant['jenis_suasana']),
          );
        },
      ),
    );
  }
}