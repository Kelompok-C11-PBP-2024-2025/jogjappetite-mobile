import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  List<Ratings> ratingsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Kita langsung panggil fetchRatings()
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();
      // Sesuaikan dengan path yang benar
      // Untuk testing, kita bisa hardcode id restaurant (misal: 1)
      final response =
          await request.get('http://127.0.0.1:8000/restaurants/flutter/1/');

      // Parse response menjadi list of Ratings
      if (response != null && response['ratings'] != null) {
        setState(() {
          ratingsList = (response['ratings'] as List)
              .map((rating) => Ratings.fromJson(rating))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Tampilkan error ke user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  // ... rest of the code remains the same ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF5F5F5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Ulasan Pengguna",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFDC2626),
                ),
              ),
              centerTitle: true,
            ).animate().fadeIn().slideY(begin: -0.3),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFDC2626),
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFFDC2626),
                      onRefresh: fetchRatings,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: ratingsList.length,
                        itemBuilder: (context, index) {
                          final rating = ratingsList[index];
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey[200]!),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFDC2626),
                                        child: Text(
                                          rating.userInitials,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rating.username,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              rating.createdAt.split('T')[0],
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            index < rating.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: const Color(0xFFDC2626),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (rating.menuReview.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'Ulasan Menu',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rating.menuReview,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ],
                                  if (rating.restaurantReview.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'Ulasan Restoran',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rating.restaurantReview,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ],
                                  if (rating.pesanRating.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'Pesan Tambahan',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rating.pesanRating,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ).animate().fadeIn().slideY(
                                begin: 0.3,
                                duration:
                                    Duration(milliseconds: 300 + (index * 100)),
                              );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
