// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

String welcomeToJson(RestaurantResponse data) => json.encode(data.toJson());

class RestaurantResponse {
  String profileType;
  List<Restaurant> restaurants;
  int perPage;
  dynamic page;
  int totalPages;
  int totalRestaurants;
  int statusCode;

  RestaurantResponse({
    required this.profileType,
    required this.restaurants,
    required this.perPage,
    required this.page,
    required this.totalPages,
    required this.totalRestaurants,
    required this.statusCode,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantResponse(
        profileType: json["profile_type"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
        perPage: json["per_page"],
        page: json["page"],
        totalPages: json["total_pages"],
        totalRestaurants: json["total_restaurants"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "profile_type": profileType,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
        "per_page": perPage,
        "page": page,
        "total_pages": totalPages,
        "total_restaurants": totalRestaurants,
        "statusCode": statusCode,
      };
}

class Restaurant {
  final int id;
  final String namaRestoran;
  final String lokasi;
  final String jenisSuasana;
  final int keramaianRestoran;
  final String jenisPenyajian;
  final String ayceAtauAlacarte;
  final int hargaRataRataMakanan;
  final String gambar;
  final double averageRating;

  Restaurant({
    required this.id,
    required this.namaRestoran,
    required this.lokasi,
    required this.jenisSuasana,
    required this.keramaianRestoran,
    required this.jenisPenyajian,
    required this.ayceAtauAlacarte,
    required this.hargaRataRataMakanan,
    required this.gambar,
    required this.averageRating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? 0,
      namaRestoran: json['nama_restoran'] ?? '',
      lokasi: json['lokasi'] ?? '',
      jenisSuasana: json['jenis_suasana'] ?? '',
      keramaianRestoran: json['keramaian_restoran'] ?? 0,
      jenisPenyajian: json['jenis_penyajian'] ?? '',
      ayceAtauAlacarte: json['ayce_atau_alacarte'] ?? '',
      hargaRataRataMakanan: json['harga_rata_rata_makanan'] ?? 0,
      gambar: json['gambar'] ?? '',
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_restoran": namaRestoran,
        "lokasi": lokasi,
        "gambar": gambar,
        "jenis_suasana": jenisSuasana,
        "keramaian_restoran": keramaianRestoran,
        "jenis_penyajian": jenisPenyajian,
        "ayce_atau_alacarte": ayceAtauAlacarte,
        "harga_rata_rata_makanan": hargaRataRataMakanan,
        "average_rating": averageRating,
      };
}


DetailRestaurantResponse welcomeFromJson(String str) => DetailRestaurantResponse.fromJson(json.decode(str));

class DetailRestaurantResponse {
    bool success;
    Restaurant restaurant;
    String profileType;
    List<Review> reviews;

    DetailRestaurantResponse({
        required this.success,
        required this.restaurant,
        required this.profileType,
        required this.reviews,
    });

    factory DetailRestaurantResponse.fromJson(Map<String, dynamic> json) => DetailRestaurantResponse(
        success: json["success"],
        restaurant: Restaurant.fromJson(json["restaurant"]),
        profileType: json["profile_type"],
        reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "restaurant": restaurant.toJson(),
        "profile_type": profileType,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
    };
}

class Review {
    int id;
    String userInitials;
    String username;
    String menuReview;
    int rating;
    String pesanRating;
    String createdAt;

    Review({
        required this.id,
        required this.userInitials,
        required this.username,
        required this.menuReview,
        required this.rating,
        required this.pesanRating,
        required this.createdAt,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userInitials: json["user_initials"],
        username: json["username"],
        menuReview: json["menu_review"],
        rating: json["rating"],
        pesanRating: json["pesan_rating"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_initials": userInitials,
        "username": username,
        "menu_review": menuReview,
        "rating": rating,
        "pesan_rating": pesanRating,
        "created_at": createdAt,
    };
}
