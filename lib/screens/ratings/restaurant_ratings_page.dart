import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';
import 'package:jogjappetite_mobile/screens/ratings/rating_add.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_information.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_card_detailed_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RestaurantRatingsPage extends StatefulWidget {
  final int restaurantId;
  final String restaurantName;

  const RestaurantRatingsPage({
    Key? key,
    required this.restaurantId,
    required this.restaurantName,
  }) : super(key: key);

  @override
  State<RestaurantRatingsPage> createState() => _RestaurantRatingsPageState();
}

class _RestaurantRatingsPageState extends State<RestaurantRatingsPage> {
  RestaurantDetails? details;
  bool isLoading = true;
  String? error;

  String? loggedInUsername;
  String? loggedInUserType;
  bool isUserInfoLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserInfo().then((_) {
      fetchRestaurantDetails();
    });
  }

  Future<void> _getUserInfo() async {
    final request = context.read<CookieRequest>();
    try {
      final response =
          await request.get('http://127.0.0.1:8000/auth/get-user-data/');
      if (response['status'] == 'success' &&
          response['is_authenticated'] == true &&
          response['user'] != null) {
        setState(() {
          loggedInUserType = response['user']['user_type'];
          loggedInUsername = response['user']['username'];
        });
      } else {
        setState(() {
          loggedInUserType = null;
          loggedInUsername = null;
        });
      }
    } catch (e) {
      print('Error fetching user info: $e');
    } finally {
      setState(() {
        isUserInfoLoading = false;
      });
    }
  }

  Future<void> fetchRestaurantDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/ratings/restaurants/flutter/${widget.restaurantId}/',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          details = RestaurantDetails.fromJson(json.decode(response.body));
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load restaurant details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || isUserInfoLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                details!.restaurant.namaRestoran,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Image.network(
                details!.restaurant.gambar,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant,
                            size: 40, color: Colors.grey[600]),
                        const SizedBox(height: 4),
                        Text(
                          'No Image Available',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Restaurant Details and Menus section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Details Card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant Details',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DetailItem(
                            label: 'Location',
                            value: details!.restaurant.lokasi,
                          ),
                          DetailItem(
                            label: 'Atmosphere',
                            value: details!.restaurant.jenisSuasana,
                          ),
                          DetailItem(
                            label: 'Restaurant Crowd Level',
                            value: details!.restaurant.keramaianRestoran
                                .toString(),
                          ),
                          DetailItem(
                            label: 'Serving Style',
                            value: details!.restaurant.jenisPenyajian,
                          ),
                          DetailItem(
                            label: 'All You Can Eat or A La Carte',
                            value: details!.restaurant.ayceAtauAlacarte,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24), // Space between cards

                  // Menus Card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Menus',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...details!.menus.map((menu) => MenuItem(menu: menu)),
                        ],
                      ),
                    ),
                  ),

                  AddRatingButton(
                    details: details!,
                    onSuccess: () {
                      // Refresh the ratings list
                      fetchRestaurantDetails();
                    },
                  ),

                  const SizedBox(height: 24),
                  if (details!.ratings.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Customer Ratings',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...details!.ratings.map((rating) => RestaurantRatingCard(
                          rating: rating,
                          loggedInUsername: loggedInUsername,
                          menus: details!.menus,
                          restaurantId:
                              widget.restaurantId, // Kirim restaurantId ke Card
                          onSuccess: () {
                            fetchRestaurantDetails();
                          },
                        )),
                  ],
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
