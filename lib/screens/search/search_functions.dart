import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jogjappetite_mobile/screens/search/search_result_food.dart';
import 'package:jogjappetite_mobile/screens/search/search_result_not_found.dart';
import 'package:jogjappetite_mobile/screens/search/search_result_recommendation.dart';
import 'package:jogjappetite_mobile/screens/search/search_result_resto.dart';
import 'dart:convert'; // For JSON encoding/decoding

Future<void> saveSearchHistory(String query, CookieRequest request) async {
  await request.post(
    'http://127.0.0.1:8000/search/save-search-history-flutter/',
    {'search_query': query},
  );
}

Future<void> searchFood(String query, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/search/food-search-flutter/'),
    body: jsonEncode(<String, String>{
      'search_query': query,
    }),
  );

  final data = json.decode(response.body);

  if (data['found'] == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultFood(data:data['menus']),
      ),
    );
  } else if (data['found'] == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultRecommendation(data:data['menus']),
      ),
    );
  } else if (data['found'] == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultNotFound(query: query),
      ),
    );
  }
}

Future<void> searchRestaurant(String query, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/search/resto-search-flutter/'),
    body: jsonEncode(<String, String>{
      'search_query': query,
    }),
  );

  final data = json.decode(response.body);

  if (data['found'] == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultResto(data:data['restaurants']),
      ),
    );
  } else if (data['found'] == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultRecommendation(data:data['restaurants']),
      ),
    );
  } else if (data['found'] == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultNotFound(query: query),
      ),
    );
  }
}