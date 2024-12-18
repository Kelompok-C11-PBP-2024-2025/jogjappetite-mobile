// models/ratings.dart
import 'package:jogjappetite_mobile/models/restaurant.dart';

class MainPageResponse {
  final List<Rating> latestRatings;
  final List<Rating>? userRatings;
  final List<Restaurant> highestRatedRestaurants;
  final bool isAuthenticated;

  MainPageResponse({
    required this.latestRatings,
    this.userRatings,
    required this.highestRatedRestaurants,
    required this.isAuthenticated,
  });

  factory MainPageResponse.fromJson(Map<String, dynamic> json) {
    return MainPageResponse(
      latestRatings: (json['latest_ratings'] as List)
          .map((rating) => Rating.fromJson(rating))
          .toList(),
      userRatings: json['user_ratings'] != null
          ? (json['user_ratings'] as List)
              .map((rating) => Rating.fromJson(rating))
              .toList()
          : null,
      highestRatedRestaurants: (json['highest_rated_restaurants'] as List)
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList(),
      isAuthenticated: json['is_authenticated'] ?? false,
    );
  }
}

class Rating {
  final int id;
  final String userInitials;
  final String username;
  final String menuReview;
  final String? restaurantReview;
  final int rating;
  final String pesanRating;
  final DateTime createdAt;
  // Add these new fields
  final int restaurantId;
  final String restaurantName;

  Rating({
    required this.id,
    required this.userInitials,
    required this.username,
    required this.menuReview,
    this.restaurantReview,
    required this.rating,
    required this.pesanRating,
    required this.createdAt,
    required this.restaurantId, // New field
    required this.restaurantName, // New field
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    print('Parsing Rating JSON: ${json['restaurant_id']}'); // Debug line
    return Rating(
      id: json['id'] ?? 0,
      userInitials: json['user_initials'] ?? '',
      username: json['username'] ?? '',
      menuReview: json['menu_review'] ?? '',
      restaurantReview: json['restaurant_review'],
      rating: json['rating'] ?? 0,
      pesanRating: json['pesan_rating'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      restaurantId: json['restaurant_id'] ?? 0,
      restaurantName: json['restaurant_name'] ?? '',
    );
  }
}

class Menu {
  final int id;
  final String namaMenu;
  final int harga;
  final List<String> categories;

  Menu({
    required this.id,
    required this.namaMenu,
    required this.harga,
    required this.categories,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      namaMenu: json['nama_menu'],
      harga: json['harga'],
      categories: List<String>.from(json['categories']),
    );
  }
}

// Model untuk Rating
class RestaurantRating {
  final int id;
  final String userInitials;
  final String username;
  final String menuReview;
  final String? restaurantReview;
  final int rating;
  final String pesanRating;
  final String createdAt;

  RestaurantRating({
    required this.id,
    required this.userInitials,
    required this.username,
    required this.menuReview,
    this.restaurantReview,
    required this.rating,
    required this.pesanRating,
    required this.createdAt,
  });

  factory RestaurantRating.fromJson(Map<String, dynamic> json) {
    return RestaurantRating(
      id: json['id'],
      userInitials: json['user_initials'],
      username: json['username'],
      menuReview: json['menu_review'],
      restaurantReview: json['restaurant_review'],
      rating: json['rating'],
      pesanRating: json['pesan_rating'],
      createdAt: json['created_at'],
    );
  }
}

class RestaurantDetails {
  final Restaurant restaurant;
  final List<Menu> menus;
  final List<RestaurantRating> ratings;
  final double averageRating;
  final int reviewsCount;

  RestaurantDetails({
    required this.restaurant,
    required this.menus,
    required this.ratings,
    required this.averageRating,
    required this.reviewsCount,
  });

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) {
    return RestaurantDetails(
      restaurant: Restaurant.fromJson(json['restaurant']),
      menus: (json['menus'] as List).map((m) => Menu.fromJson(m)).toList(),
      ratings: (json['ratings'] as List)
          .map((r) => RestaurantRating.fromJson(r))
          .toList(),
      averageRating: json['average_rating'].toDouble(),
      reviewsCount: json['reviews_count'],
    );
  }
}
