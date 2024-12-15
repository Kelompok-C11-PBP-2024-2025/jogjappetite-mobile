import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogjappetite_mobile/models/restaurant.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_information.dart';
import 'package:jogjappetite_mobile/screens/restaurant/edit_restaurant.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_ratings_page.dart';

class DetailRestaurantPage extends StatefulWidget {
  final int restaurantId;

  const DetailRestaurantPage({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  _DetailRestaurantPageState createState() => _DetailRestaurantPageState();
}

class _DetailRestaurantPageState extends State<DetailRestaurantPage> {
  bool isLoading = true;
  String? error;
  Restaurant? restaurant;
  String? profileType;

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
  }

  Future<void> fetchRestaurantDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final request = context.read<CookieRequest>();
      final response = await request.get(
        'http://127.0.0.1:8000/restaurant/api/owner/${widget.restaurantId}/',
      );

      if (response != null) {
        final data = DetailRestaurantResponse.fromJson(response);
        setState(() {
          restaurant = data.restaurant;
          profileType = data.profileType;
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error!),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: fetchRestaurantDetails,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurant!.namaRestoran,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Image.network(
                restaurant!.gambar,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              if (profileType == "owner")
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRestaurantPage(
                            restaurant: restaurant!,
                          ),
                        ),
                      );
                      if (result == true) {
                        fetchRestaurantDetails();
                      }
                    } else if (value == 'delete') {
                      _showDeleteConfirmation();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
            ],
          ),
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
                            'Detail Restoran',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DetailItem(
                            label: 'Lokasi',
                            value: restaurant!.lokasi,
                          ),
                          DetailItem(
                            label: 'Suasana',
                            value: restaurant!.jenisSuasana,
                          ),
                          DetailItem(
                            label: 'Keramaian',
                            value: restaurant!.keramaianRestoran.toString(),
                          ),
                          DetailItem(
                            label: 'Jenis Penyajian',
                            value: restaurant!.jenisPenyajian,
                          ),
                          DetailItem(
                            label: 'All You Can Eat atau A La Carte',
                            value: restaurant!.ayceAtauAlacarte,
                          ),
                            DetailItem(
                            label: 'Harga Rata-rata',
                            value: 'Rp ${restaurant!.hargaRataRataMakanan}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Statistics Card
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
                            'Statistik Restoran',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            DetailItem(
                            label: 'Total Ulasan',
                            value: '0',
                          ),
                            DetailItem(
                            label: 'Rating Rata-rata',
                            value: '${restaurant!.averageRating}/5',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Statistics Card
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
                            'Ulasan',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            const DetailItem(
                            label: 'Total Ulasan',
                            value: 'Coming Soon',
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantRatingsPage(
                            restaurantId: restaurant!.id,
                            restaurantName: restaurant!.namaRestoran,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('View Ratings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Restaurant'),
          content: const Text('Are you sure you want to delete this restaurant?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final request = context.read<CookieRequest>();
                  final response = await request.post(
                    'http://127.0.0.1:8000/restaurant/api/owner/${restaurant!.id}/delete/',
                    {},
                  );

                  if (response['success'] == true) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Restaurant deleted successfully')),
                    );
                    Navigator.of(context).pop(true); // Return to previous screen
                  } else {
                    throw response['message'] ?? 'Failed to delete restaurant';
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
