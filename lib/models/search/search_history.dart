// To parse this JSON data, do
//
//     final searchHistory = searchHistoryFromJson(jsonString);

import 'dart:convert';

List<SearchHistory> searchHistoryFromJson(String str) => List<SearchHistory>.from(json.decode(str).map((x) => SearchHistory.fromJson(x)));

String searchHistoryToJson(List<SearchHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchHistory {
    String model;
    int pk;
    Fields fields;

    SearchHistory({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory SearchHistory.fromJson(Map<String, dynamic> json) => SearchHistory(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String query;
    DateTime createdAt;

    Fields({
        required this.user,
        required this.query,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        query: json["query"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "query": query,
        "created_at": createdAt.toIso8601String(),
    };
}
