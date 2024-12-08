import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
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

Future<void> searchFood(String query, CookieRequest request, BuildContext context) async {
  final response = await request.post(
    'http://127.0.0.1:8000/search/food-search-flutter/',
    {'search_query': query},
  );

  if (response['found'] == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultFood(data: response['menus']),
      ),
    );
  } else if (response['found'] == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultRecommendation(data: response['menus']),
      ),
    );
  } else if (response['found'] == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultNotFound(query: query),
      ),
    );
  }
}

Future<void> searchRestaurant(String query, CookieRequest request, BuildContext context) async {
  final response = await request.post(
    'http://127.0.0.1:8000/search/resto-search-flutter/',
    {'search_query': query},
  );

  if (response['found'] == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultResto(data: response['restaurants']),
      ),
    );
  } else if (response['found'] == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultRecommendation(data: response['restaurants']),
      ),
    );
  } else if (response['found'] == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultNotFound(query: query),
      ),
    );
  }
}