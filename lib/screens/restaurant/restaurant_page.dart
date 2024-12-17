import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/models/restaurant.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_card.dart';
import 'package:jogjappetite_mobile/screens/restaurant/add_restaurant.dart';
import 'package:jogjappetite_mobile/screens/restaurant/detail_restaurant.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  RestaurantResponse? restaurantData;
  bool isLoading = true;
  bool isLoadingMore = false;
  String? error;
  TextEditingController searchController = TextEditingController();
  List<Restaurant> filteredRestaurants = [];
  int currentPage = 1;
  int perPage = 12;
  bool hasMoreData = true;
  ScrollController _scrollController = ScrollController();
  int totalItems = 0; // Add this variable
  bool get _hasReachedMax => filteredRestaurants.length >= totalItems;
  String? profileType;
  String currentSearchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchMainPageData(context.read<CookieRequest>());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_hasReachedMax) return;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.95) {
      if (!isLoadingMore && hasMoreData) {
        loadMoreData(context.read<CookieRequest>());
      }
    }
  }

  Future<void> loadMoreData(CookieRequest request) async {
    if (isLoadingMore || _hasReachedMax) {
      setState(() {
        hasMoreData = false;
      });
      return;
    }

    setState(() {
      isLoadingMore = true;
    });

    try {
      final response = await request.get(
        "http://127.0.0.1:8000/restaurant/api/get-data?page=${currentPage + 1}&per_page=${perPage}&search=${Uri.encodeComponent(currentSearchQuery)}"
      );

      if (response != null) {
        final newData = RestaurantResponse.fromJson(response);
        if (newData.restaurants.isNotEmpty) {
          setState(() {
            restaurantData!.restaurants.addAll(newData.restaurants);
            filteredRestaurants = restaurantData!.restaurants;
            currentPage++;
            hasMoreData = filteredRestaurants.length < newData.totalRestaurants;
            totalItems = newData.totalRestaurants;
            isLoadingMore = false;
          });
        } else {
          setState(() {
            hasMoreData = false;
            isLoadingMore = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        hasMoreData = false;
        isLoadingMore = false;
      });
    }
  }

  Future<void> fetchMainPageData(CookieRequest request) async {
    setState(() {
      isLoading = true;
      error = null;
      currentPage = 1;
      hasMoreData = true;
      totalItems = 0;
      filteredRestaurants = []; // Clear existing data
      restaurantData = null; // Reset restaurant data
      profileType = null;
    });

    try {
      final response = await request.get(
        "http://127.0.0.1:8000/restaurant/api/get-data?page=1&per_page=${perPage}&search=${Uri.encodeComponent(currentSearchQuery)}"
      );

      if (response != null) {
        final data = RestaurantResponse.fromJson(response);
        setState(() {
          restaurantData = data;
          filteredRestaurants = data.restaurants;
          totalItems = data.totalRestaurants;
          hasMoreData = filteredRestaurants.length < totalItems;
          profileType = data.profileType; // Store the profile type
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load data';
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

  void filterRestaurants(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        currentSearchQuery = query;
      });
      fetchMainPageData(context.read<CookieRequest>());
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error!),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => fetchMainPageData(request),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Initialize filtered restaurants if empty
    if (filteredRestaurants.isEmpty && restaurantData != null) {
      filteredRestaurants = restaurantData!.restaurants;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => fetchMainPageData(request),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search restaurants...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: filterRestaurants,
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final restaurant = filteredRestaurants[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: RestaurantCard(
                      restaurant: restaurant,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRestaurantPage(
                              restaurantId: restaurant.id
                            ),
                          ),
                        );
                        // If restaurant was deleted, refresh the page
                        if (result == true) {
                          fetchMainPageData(request);
                        }
                      },
                    ),
                  );
                },
                childCount: filteredRestaurants.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 80,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: isLoadingMore
                      ? const CircularProgressIndicator()
                      : !hasMoreData
                          ? const Text('No more restaurants')
                          : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: profileType == "owner"
        ? FloatingActionButton(
            onPressed: () async {  // Make this async
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddRestaurantPage(),
                ),
              );
              if (result == true) {  // Check if restaurant was added successfully
                fetchMainPageData(request);
              }
            },
            child: const Icon(Icons.add),
          )
        : null,
    );
  }
}
