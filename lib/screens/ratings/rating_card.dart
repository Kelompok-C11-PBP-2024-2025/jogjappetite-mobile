import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jogjappetite_mobile/models/ratings.dart';

class RatingCard extends StatelessWidget {
  final Rating rating;

  const RatingCard({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced padding
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure minimum height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info - More compact
              Row(
                children: [
                  CircleAvatar(
                    radius: 16, // Smaller avatar
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      rating.userInitials,
                      style: TextStyle(
                        fontSize: 12, // Smaller font
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
                          rating.username,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          DateFormat('MMM d, y').format(rating.createdAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Restaurant Review - if exists
              if (rating.restaurantReview?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    rating.restaurantReview!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Menu Review - Compact
              Text(
                'Menu: ${rating.menuReview}',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Stars and Message in one row to save space
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Stars
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16, // Smaller stars
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  // Message
                  Expanded(
                    child: Text(
                      rating.pesanRating,
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
