// models/ratings.dart

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

  Rating({
    required this.id,
    required this.userInitials,
    required this.username,
    required this.menuReview,
    this.restaurantReview,
    required this.rating,
    required this.pesanRating,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
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
