import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/explore/show_cluster.dart';
import 'package:jogjappetite_mobile/widgets/navbar.dart';

class ExplorePage extends StatelessWidget {
  // Tambahkan mapping untuk cluster names
  final Map<String, String> clusterMapping = {
    'Rice': 'nasi',
    'Noodles': 'mie',
    'Meatball': 'bakso',
    'Soto': 'soto',
    'Snacks': 'snacks',
    'Sweets': 'manis-manis',
    'Beverages': 'minuman',
    'Indonesian': 'indonesian',
    'Japanese': 'japanese',
    'Asian': 'asian',
    'Western': 'western'
  };

  // Daftar gambar untuk setiap card
  final List<String> imageUrls = [
    'https://i.pinimg.com/564x/5e/06/b4/5e06b47cac34547f981c479cf4943b0f.jpg',
    'https://i.pinimg.com/736x/a7/c5/d1/a7c5d1bb9a7bcb9deedb6727b4c26adb.jpg',
    'https://i.pinimg.com/474x/3a/9a/43/3a9a437acebfed3f968caadfd3df055d.jpg',
    'https://i.pinimg.com/control/474x/1d/e4/a1/1de4a19e2d70724d71ad912cec05885d.jpg',
    'https://i.pinimg.com/474x/eb/33/c7/eb33c7632c8e848308a4977e11fa3c18.jpg',
    'https://i.pinimg.com/474x/01/c7/01/01c7019cf3e709aeb749fab51dc56f5c.jpg',
    'https://i.pinimg.com/474x/15/7a/e7/157ae7ce3f70fe6582928ff1d73b0940.jpg',
    'https://i.pinimg.com/control/474x/bb/ab/54/bbab54c699d8ac151e6c36627e6b2a76.jpg',
    'https://i.pinimg.com/control/474x/b1/21/41/b121419a4f6e16be30b58364b1b5681c.jpg',
    'https://i.pinimg.com/474x/1b/b7/9a/1bb79ad97c3356e971701c76b577751f.jpg',
    'https://i.pinimg.com/474x/37/fe/c4/37fec482252df3c0e6604e68aa72f97f.jpg'
  ];

  // Daftar nama untuk setiap card
  final List<String> cardNames = [
    'Rice',
    'Noodles',
    'Meatball',
    'Soto',
    'Snacks',
    'Sweets',
    'Beverages',
    'Indonesian',
    'Japanese',
    'Asian',
    'Western'
  ];

  // Daftar deskripsi untuk setiap card
  final List<String> descriptions = [
    'The main dish is rice-based, prepared with various spices and cooking techniques. This food is typically served as a staple dish in various culinary cultures, especially in Asia.',
    'A variety of noodle dishes that can be enjoyed with broth or without, offering diverse textures and flavors. This category highlights the flexibility of noodles as a base ingredient, combined with spices and accompaniments.',
    'This category offers dishes based on processed meat shaped into balls and usually served with simple accompaniments. The dishes have a soft texture and are often accompanied by broth or sauce.',
    'A broth-based dish originating from various regions, characterized by its strong flavor and rich aroma. Each variation features a unique combination of meat, vegetables, and spices.',
    ' A variety of convenient and light snacks, perfect to enjoy as a quick bite. With a range of textures and flavors, both savory and sweet, this category is a popular choice to enjoy anytime.',
    ' Desserts that highlight sweet flavors, typically served in light and refreshing forms. This category offers a delightful experience to conclude the main course.',
    'A variety of drinks ranging from refreshing to warm. This category includes beverages that are suitable for various occasions, whether as a complement to a meal or enjoyed on their own.',
    'Traditional dishes that reflect the richness of Indonesian culture with complex flavors. The dishes in this category often involve the use of distinctive spices and traditional cooking methods.',
    'Japanese dishes known for their simple yet aesthetic presentation and balanced flavors. This category emphasizes the freshness of ingredients and cooking techniques that preserve the authenticity of the taste.',
    'A collection of signature dishes from various Asian countries, known for their rich use of spices and fresh ingredients. The dishes in this category offer a balanced combination of savory, sweet, spicy, and sour flavors.',
    'Western cuisine offering generous portions with a focus on key ingredients like meat, cheese, and bread. The dishes are often characterized by bold flavors and modern cooking techniques.'
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Page'),
      ),
      body: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Gunakan cluster mapping untuk mendapatkan key yang sesuai
              String clusterKey = clusterMapping[cardNames[index]] ?? cardNames[index].toLowerCase();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowClusterPage(
                    clusterName: clusterKey,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5, // Menambahkan bayangan
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  // Gambar di sebelah kiri
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Memberikan ruang antara gambar dan teks
                  
                  // Kolom untuk nama dan deskripsi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Card di bawah gambar
                        Text(
                          cardNames[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5), // Memberikan ruang antara nama dan deskripsi
                        
                        // Deskripsi card
                        Text(
                          descriptions[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 3, // Membatasi deskripsi agar tidak terlalu panjang
                          overflow: TextOverflow.ellipsis, // Menambahkan elipsis jika teks terlalu panjang
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
