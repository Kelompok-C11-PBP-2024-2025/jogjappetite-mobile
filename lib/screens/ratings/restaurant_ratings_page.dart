import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
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
    if (isLoading) {
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
              padding: const EdgeInsets.all(
                  24), // Consistent outer padding for the whole section
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

class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(),
            ),
          ),
        ],
      ),
    );
  }
}

// Update the MenuItem widget
class MenuItem extends StatelessWidget {
  final Menu menu;

  const MenuItem({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${menu.namaMenu} - ${NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(menu.harga)}',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          if (menu.categories.isNotEmpty)
            Text(
              'Categories: ${menu.categories.join(", ")}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}

class RestaurantRatingCard extends StatelessWidget {
  final RestaurantRating rating;

  const RestaurantRatingCard({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar with initials
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      rating.userInitials,
                      style: GoogleFonts.outfit(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Username and reviewed item
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rating.username,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Reviewed ${rating.menuReview}',
                        style: GoogleFonts.outfit(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating score
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.rating.toString(),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Review message
            if (rating.pesanRating.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                rating.pesanRating,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ],
            // Review date
            const SizedBox(height: 8),
            Text(
              rating.createdAt,
              style: GoogleFonts.outfit(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRatingButton extends StatefulWidget {
  final RestaurantDetails details;
  final Function onSuccess;

  const AddRatingButton({
    Key? key,
    required this.details,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<AddRatingButton> createState() => _AddRatingButtonState();
}

class _AddRatingButtonState extends State<AddRatingButton> {
  String? userType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Future<void> _getUserType() async {
    final request = context.read<CookieRequest>();
    try {
      final response =
          await request.get('http://127.0.0.1:8000/auth/get-user-type/');
      print('User type response: $response');

      setState(() {
        userType = response['user_type'];
        isLoading = false;
      });
    } catch (e) {
      print('Error getting user type: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Card(
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
              'Add Rating',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (userType == null) ...[
              // Not logged in
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please log in to leave a review',
                        style: GoogleFonts.outfit(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (userType == "restaurant") ...[
              // Restaurant owner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Restaurant owners cannot leave reviews',
                        style: GoogleFonts.outfit(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (userType == "customer") ...[
              // Customer
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => AddRatingDialog(
                      details: widget.details,
                      onSuccess: () {
                        Navigator.pop(dialogContext);
                        widget.onSuccess();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Write a review',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ] else ...[
              // Unknown user type
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.login_rounded, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please log in to write a review',
                        style: GoogleFonts.outfit(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AddRatingDialog extends StatefulWidget {
  final RestaurantDetails details;
  final Function onSuccess;

  const AddRatingDialog({
    Key? key,
    required this.details,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<AddRatingDialog> createState() => _AddRatingDialogState();
}

class _AddRatingDialogState extends State<AddRatingDialog> {
  int selectedRating = 0;
  String review = '';
  int? selectedMenuId; // Changed from List to single int
  bool isSubmitting = false;
  Future<void> submitRating() async {
    final request = context.read<CookieRequest>();

    if (selectedRating == 0 || selectedMenuId == null || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/ratings/add-rating-flutter/',
        {
          'rating': selectedRating.toString(),
          'pesan_rating': review,
          'menu_review': selectedMenuId.toString(),
          'restaurant_id': widget.details.restaurant.id.toString(),
        },
      );

      if (response['success'] == true) {
        if (mounted) {
          // Panggil onSuccess untuk refresh data
          widget.onSuccess();

          // Tampilkan snackbar setelah dialog tertutup
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rating submitted successfully'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['error'] ?? 'Failed to submit rating'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('Error during submission: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

// Helper method to show error messages
  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

// Helper method to show success messages
  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

// Helper method to get appropriate error message based on status code
  String _getErrorMessage(int statusCode, Map<String, dynamic> errorData) {
    switch (statusCode) {
      case 400:
        return errorData['error'] ??
            errorData['message'] ??
            'Invalid request. Please check your input.';
      case 401:
        return 'Please log in to submit a rating.';
      case 403:
        return 'You do not have permission to submit this rating.';
      case 404:
        return 'The requested resource was not found.';
      case 429:
        return 'Too many attempts. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Failed to submit rating. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Write a Review',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Rating',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Menu Item',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // Changed to radio-style selection
              Wrap(
                spacing: 8,
                children: widget.details.menus.map((menu) {
                  return ChoiceChip(
                    selected: selectedMenuId == menu.id,
                    label: Text(menu.namaMenu),
                    onSelected: (selected) {
                      setState(() {
                        selectedMenuId = selected ? menu.id : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Review',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => setState(() => review = value),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.outfit(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : submitRating,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Submit',
                              style: GoogleFonts.outfit(),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
