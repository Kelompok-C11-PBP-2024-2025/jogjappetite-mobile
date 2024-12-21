import 'dart:convert';

List<Favorite> favoriteFromJson(String str) => List<Favorite>.from(json.decode(str).map((x) => Favorite.fromJson(x)));

String favoriteToJson(List<Favorite> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorite {
  int id;
  String user;
  Restaurant restaurant;
  String notes;
  DateTime createdAt;

  Favorite({
    required this.id,
    required this.user,
    required this.restaurant,
    required this.notes,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["id"],
        user: json["user"],
        restaurant: Restaurant.fromJson(json["restaurant"]), // Nested object
        notes: json["notes"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "restaurant": restaurant.toJson(), // Convert nested object
        "notes": notes,
        "created_at": createdAt.toIso8601String(),
      };
}

class Restaurant {
  int id;
  String namaRestoran;
  String lokasi;
  String gambar;
  double averageRating;

  Restaurant({
    required this.id,
    required this.namaRestoran,
    required this.lokasi,
    required this.gambar,
    required this.averageRating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        namaRestoran: json["nama_restoran"],
        lokasi: json["lokasi"],
        gambar: json["gambar"],
        averageRating: json["average_rating"] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_restoran": namaRestoran,
        "lokasi": lokasi,
        "gambar": gambar,
        "average_rating": averageRating,
      };
}