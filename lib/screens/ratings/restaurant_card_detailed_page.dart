import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';
import 'package:jogjappetite_mobile/screens/ratings/rating_edit.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_ratings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';
import 'package:jogjappetite_mobile/screens/ratings/rating_edit.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_ratings_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RestaurantRatingCard extends StatelessWidget {
  final RestaurantRating rating;
  final String? loggedInUsername;
  final List<Menu> menus;
  final int restaurantId;
  final VoidCallback onSuccess;

  const RestaurantRatingCard({
    Key? key,
    required this.rating,
    required this.loggedInUsername,
    required this.menus,
    required this.restaurantId,
    required this.onSuccess,
  }) : super(key: key);

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Rating'),
          content: const Text('Are you sure you want to delete this rating?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Close the dialog
                await _deleteRating(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRating(BuildContext context) async {
    final request = context.read<CookieRequest>();

    // Print cookies to verify what you're sending
    print("Cookies before delete request: ${request.cookies}");

    try {
      final url = Uri.parse(
          'http://127.0.0.1:8000/ratings/delete-rating-flutter/$restaurantId/${rating.id}/');

      // Print the URL to verify correctness
      print("Deleting rating at: $url");

      // Send DELETE request
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': request.cookies.entries
              .map((e) => '${e.key}=${e.value}')
              .join('; '),
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        onSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['error'] ?? 'Failed to delete rating'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print("Error during delete request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canEdit =
        (loggedInUsername != null && rating.username == loggedInUsername);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
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
            const SizedBox(height: 8),
            Text(
              rating.createdAt,
              style: GoogleFonts.outfit(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            if (canEdit)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        int? initialMenuId;
                        for (var m in menus) {
                          if (m.namaMenu == rating.menuReview) {
                            initialMenuId = m.id;
                            break;
                          }
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) => EditRatingDialog(
                            rating: rating,
                            menus: menus,
                            initialMenuId: initialMenuId,
                            restaurantId: restaurantId,
                            onSuccess: () {
                              Navigator.pop(dialogContext);
                              onSuccess();
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      onPressed: () => _showDeleteConfirmation(context),
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
