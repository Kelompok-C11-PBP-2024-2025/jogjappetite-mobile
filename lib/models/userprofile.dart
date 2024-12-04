import 'dart:convert';

class UserProfile {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String userType;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.userType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        fullName: json["full_name"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "full_name": fullName,
        "user_type": userType,
      };
}

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());
