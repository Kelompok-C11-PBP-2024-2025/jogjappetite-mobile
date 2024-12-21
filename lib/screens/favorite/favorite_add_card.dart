import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/models/favorite.dart';

class FavoriteAddCard extends StatelessWidget {
  final Favorite favorite;
  final Function(String note) onAdd;

  const FavoriteAddCard({Key? key, required this.favorite, required this.onAdd}) : super(key: key);

  void showAddNoteDialog(BuildContext context) {
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note*'),
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: 'Why are you adding this restaurant to your favorite?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Ubah warna teks menjadi putih
                backgroundColor: Colors.red, // Warna latar belakang merah
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (noteController.text.isNotEmpty) {
                  onAdd(noteController.text);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in the note before submitting.'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Ubah warna teks menjadi putih
                backgroundColor: Colors.green, // Warna latar belakang hijau
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = favorite.restaurant;
    final averageRating = restaurant.averageRating ?? 0.0;

    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
            ),
            child: restaurant.gambar != null && restaurant.gambar.isNotEmpty
                ? Image.network(
                    restaurant.gambar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.restaurant, size: 40, color: Colors.grey[600]);
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant, size: 40, color: Colors.grey[600]),
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
                  ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.namaRestoran,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('Location: ${restaurant.lokasi}'),
                  Text('Notes: ${favorite.notes}'),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < averageRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => showAddNoteDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
