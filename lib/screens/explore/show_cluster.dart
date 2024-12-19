import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';  // Sesuaikan dengan nama package Anda

class ShowClusterPage extends StatefulWidget {
  final String clusterName;

  const ShowClusterPage({Key? key, required this.clusterName}) : super(key: key);

  @override
  _ShowClusterPageState createState() => _ShowClusterPageState();
}

class _ShowClusterPageState extends State<ShowClusterPage> {
  List<dynamic> menuItems = [];
  List<dynamic> bookmarkedItems = [];
  bool isLoading = true;
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    fetchClusterMenus();
    checkLoginStatus().then((_) {
      if (isUserLoggedIn) {
        fetchUserBookmarks();
      }
    });
  }

  Future<void> fetchClusterMenus() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/cluster-menus/${widget.clusterName}/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          menuItems = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data menu');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchRestaurantDetails(String restaurantName) async {
    try {
      print('Mencoba mengambil detail untuk restaurant: $restaurantName');
      final uri = Uri.parse('http://127.0.0.1:8000/get_restaurant_details/$restaurantName/');
      

      final response = await http.get(uri);
      

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        // print('Data yang diterima: $decodedData');
        return decodedData;
      } else {
        print('Gagal dengan status code: ${response.statusCode}');
        throw Exception('Gagal memuat data restaurant');
      }
    } catch (e) {
      print('Error detail: $e');
      throw Exception('Terjadi kesalahan saat memuat data');
    }
  }

  Future<void> checkLoginStatus() async {
    print('Memeriksa status login...');
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://127.0.0.1:8000/auth/get-user-type/');
      
      print('Response: $response');

      if (response['user_type'] != null) {
        setState(() {
          isUserLoggedIn = true;
        });
        print('User logged in with type: ${response['user_type']}');
      } else {
        setState(() {
          isUserLoggedIn = false;
        });
        print('User not logged in');
      }
    } catch (e) {
      print('Error checking login status: $e');
      setState(() {
        isUserLoggedIn = false;
      });
      print('Status login diset ke false karena error');
    }
  }

  Future<void> toggleBookmark(int menuId) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.post(
        'http://127.0.0.1:8000/toggle_bookmark/$menuId/',
        {},
      );

      print('Toggle bookmark response: $response');

      if (response['status'] == 'error') {
        throw Exception(response['message']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      
      // Refresh bookmark list
      await fetchUserBookmarks();
    } catch (e) {
      print('Error toggling bookmark: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat mengubah bookmark')),
      );
    }
  }

  Future<void> fetchUserBookmarks() async {
    if (!isUserLoggedIn) return;
    
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://127.0.0.1:8000/get_user_bookmarks/');

      print('Fetch bookmarks response: $response');

      if (response['status'] == 'error') {
        throw Exception(response['message']);
      }

      if (response['bookmarks'] != null) {
        setState(() {
          bookmarkedItems = response['bookmarks'];
        });
      } else {
        throw Exception('Format response tidak sesuai');
      }
    } catch (e) {
      print('Error mengambil bookmark: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat daftar bookmark')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.clusterName} Menu'),
            if (isUserLoggedIn)
              Builder(
                builder: (BuildContext context) => TextButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    'View Bookmark',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        actions: null,
      ),
      endDrawer: isUserLoggedIn ? Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.orange,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Bookmarked Items',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: bookmarkedItems.isEmpty 
                ? Center(
                    child: Text('Belum ada item yang dibookmark'),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: bookmarkedItems.length,
                    itemBuilder: (context, index) {
                      final bookmark = bookmarkedItems[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.fastfood, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      bookmark['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.bookmark_remove, color: Colors.red),
                                    onPressed: () async {
                                      await toggleBookmark(bookmark['id']);
                                    },
                                    tooltip: 'Remove Bookmark',
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Restaurant: ${bookmark['restaurant']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Rp${bookmark['price']}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ) : null,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
  padding: EdgeInsets.all(12),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3, // Tetap tiga card per row
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 0.8, // Sesuaikan aspek rasio agar proporsional
  ),
  itemCount: menuItems.length,
  itemBuilder: (context, index) {
    final menu = menuItems[index];
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.fastfood,
                        size: 60,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      menu['name'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Restaurant: ${menu['restaurant'] ?? ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rp${menu['price']}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Tutup dialog menu
                        
                        // Tampilkan loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(child: CircularProgressIndicator());
                          },
                        );

                        try {
                          final restaurantData = await fetchRestaurantDetails(menu['restaurant']);
                          Navigator.pop(context); // Tutup loading

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header dengan gambar
                                        Container(
                                          height: 200,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.grey[200],
                                          ),
                                          child: restaurantData['gambar'] != null 
                                              ? Image.network(
                                                  restaurantData['gambar'],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(Icons.restaurant, size: 60, color: Colors.grey);
                                                  },
                                                )
                                              : Icon(Icons.restaurant, size: 60, color: Colors.grey),
                                        ),
                                        SizedBox(height: 16),
                                        
                                        // Nama Restaurant
                                        Text(
                                          restaurantData['nama_restoran'] ?? '',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        
                                        // Informasi detail dengan icon
                                        ListTile(
                                          leading: Icon(Icons.location_on, color: Colors.red),
                                          title: Text('Lokasi'),
                                          subtitle: Text(restaurantData['lokasi'] ?? ''),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        
                                        ListTile(
                                          leading: Icon(Icons.mood, color: Colors.blue),
                                          title: Text('Suasana'),
                                          subtitle: Text(restaurantData['jenis_suasana'] ?? ''),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        
                                        ListTile(
                                          leading: Icon(Icons.attach_money, color: Colors.green),
                                          title: Text('Harga Rata-rata'),
                                          subtitle: Text('Rp${restaurantData['harga_rata_rata_makanan'] ?? '0'}'),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        
                                        SizedBox(height: 16),
                                        
                                        // Tombol tutup
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Tutup'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } catch (e) {
                          Navigator.pop(context); // Tutup loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal memuat data restaurant: $e')),
                          );
                        }
                      },
                      child: Text('View Restaurant Details'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80, // Kurangi tinggi ikon untuk mengurangi ruang kosong
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Icon(
                    Icons.fastfood,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Pastikan padding tidak menambah ruang kosong
                    children: [
                      Text(
                        menu['name'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Restaurant: ${menu['restaurant'] ?? ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp${menu['price']}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isUserLoggedIn) Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    bookmarkedItems.any((item) => item['id'] == menu['id']) 
                      ? Icons.bookmark 
                      : Icons.bookmark_border
                  ),
                  onPressed: () => toggleBookmark(menu['id']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
)
,
    );
  }
}
