import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';
import 'package:jogjappetite_mobile/screens/ratings/restaurant_ratings_page.dart';

class RatingCard extends StatelessWidget {
  final Rating rating;

  const RatingCard({
    super.key,
    required this.rating,
  });

  void _navigateToRestaurantRatings(BuildContext context) {
    print('Navigating to restaurant ID: ${rating.restaurantId}');
    print('Restaurant name: ${rating.restaurantName}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantRatingsPage(
          restaurantId: rating.restaurantId!,
          restaurantName: rating.restaurantName!,
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            rating.userInitials ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rating.username ?? 'Anonymous',
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                DateFormat('MMM d, y')
                    .format(rating.createdAt ?? DateTime.now()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rating.restaurantName ?? 'Unknown Restaurant',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (rating.restaurantReview?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          Text(
            rating.restaurantReview!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 4),
        Text(
          'Menu: ${rating.menuReview ?? 'No menu available'}',
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < (rating.rating ?? 0) ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToRestaurantRatings(context),
      behavior: HitTestBehavior.opaque,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(context),
              const SizedBox(height: 8),
              _buildRestaurantDetails(context),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildRatingStars(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rating.pesanRating ?? 'No message available',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
