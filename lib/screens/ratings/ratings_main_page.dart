import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';
import 'package:jogjappetite_mobile/screens/ratings/rating_card.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_card.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_ratings_page.dart';

class RatingsMainPage extends StatefulWidget {
  const RatingsMainPage({Key? key}) : super(key: key);

  @override
  _RatingsMainPageState createState() => _RatingsMainPageState();
}

class _RatingsMainPageState extends State<RatingsMainPage> {
  MainPageResponse? mainPageData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchMainPageData();
  }

  Future<void> fetchMainPageData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/ratings/api/main-page/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
            'Latest Ratings from API: ${data['latest_ratings']}'); // Log hanya bagian latest_ratings

        setState(() {
          mainPageData = MainPageResponse.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Network error: $e';
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
                onPressed: fetchMainPageData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchMainPageData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Highest Rated Restaurants',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Change to 2 columns instead of 3
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85, // Adjust for better proportions
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final restaurant =
                      mainPageData!.highestRatedRestaurants[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: RestaurantCard(
                      restaurant: restaurant,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantRatingsPage(
                              restaurantId: restaurant.id,
                              restaurantName: restaurant.namaRestoran,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: mainPageData!.highestRatedRestaurants.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Text(
                      'Latest Reviews',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 180, // Adjust height as needed
                    child: AutoScrollingReviews(
                        ratings: mainPageData!.latestRatings),
                  ),
                ],
              ),
            ),
            if (mainPageData!.isAuthenticated &&
                mainPageData!.userRatings != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
                  child: Text(
                    'Your Reviews',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            if (mainPageData!.isAuthenticated &&
                mainPageData!.userRatings != null)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return RatingCard(
                        rating: mainPageData!.userRatings![index]);
                  },
                  childCount: mainPageData!.userRatings!.length,
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoScrollingReviews extends StatefulWidget {
  final List<Rating> ratings;

  const AutoScrollingReviews({Key? key, required this.ratings})
      : super(key: key);

  @override
  State<AutoScrollingReviews> createState() => _AutoScrollingReviewsState();
}

// Modified _AutoScrollingReviewsState
class _AutoScrollingReviewsState extends State<AutoScrollingReviews> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9,
      initialPage: _currentPage,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && widget.ratings.isNotEmpty) {
        if (_currentPage < widget.ratings.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ratings.isEmpty) {
      return const Center(
        child: Text('No reviews available'),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.ratings.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        final rating = widget.ratings[index];

        // Debugging data sebelum diteruskan ke RatingCard
        // print(
        //     'AutoScrollingReviews Data: restaurantId=${rating.restaurantId}, restaurantName=${rating.restaurantName}');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: RatingCard(rating: rating),
        );
      },
    );
  }
}
