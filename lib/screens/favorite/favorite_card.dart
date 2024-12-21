import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/models/restaurant.dart';

class FavoriteCard extends StatelessWidget {
  final Restaurant restaurant;

  const FavoriteCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          // Gambar Restaurant
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
            ),
            child: restaurant.gambar != null && restaurant.gambar!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      restaurant.gambar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 40);
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                      "No Image",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          // Informasi Restaurant
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.namaRestoran,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Location: ${restaurant.lokasi}',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < restaurant.averageRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
