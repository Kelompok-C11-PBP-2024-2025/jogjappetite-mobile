// To parse this JSON data, do
//
//     final ratings = ratingsFromJson(jsonString);

import 'dart:convert';

List<Ratings> ratingsFromJson(String str) =>
    List<Ratings>.from(json.decode(str).map((x) => Ratings.fromJson(x)));

String ratingsToJson(List<Ratings> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ratings {
  int id;
  String userInitials;
  String username;
  String menuReview;
  String restaurantReview;
  int rating;
  String pesanRating;
  String createdAt;

  Ratings({
    required this.id,
    required this.userInitials,
    required this.username,
    required this.menuReview,
    required this.restaurantReview,
    required this.rating,
    required this.pesanRating,
    required this.createdAt,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
        id: json["id"],
        userInitials: json["user_initials"],
        username: json["username"],
        menuReview: json["menu_review"],
        restaurantReview: json["restaurant_review"],
        rating: json["rating"],
        pesanRating: json["pesan_rating"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_initials": userInitials,
        "username": username,
        "menu_review": menuReview,
        "restaurant_review": restaurantReview,
        "rating": rating,
        "pesan_rating": pesanRating,
        "created_at": createdAt,
      };
}

class RestaurantRatingsResponse {
  final Restaurant restaurant;
  final List<Ratings> ratings;
  final List<Menu> menus;
  final double averageRating;
  final int reviewsCount;

  RestaurantRatingsResponse({
    required this.restaurant,
    required this.ratings,
    required this.menus,
    required this.averageRating,
    required this.reviewsCount,
  });

  factory RestaurantRatingsResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantRatingsResponse(
      restaurant: Restaurant.fromJson(json['restaurant']),
      ratings: (json['ratings'] as List)
          .map((rating) => Ratings.fromJson(rating))
          .toList(),
      menus:
          (json['menus'] as List).map((menu) => Menu.fromJson(menu)).toList(),
      averageRating: json['average_rating'].toDouble(),
      reviewsCount: json['reviews_count'],
    );
  }
}

class Restaurant {
  final int id;
  final String nama;
  final String deskripsi;
  final String alamat;

  Restaurant({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.alamat,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      alamat: json['alamat'],
    );
  }
}

class Menu {
  final int id;
  final String nama;
  final String deskripsi;
  final String harga;
  final List<String> clusters;

  Menu({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.clusters,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: json['harga'],
      clusters: List<String>.from(json['clusters']),
    );
  }
}
