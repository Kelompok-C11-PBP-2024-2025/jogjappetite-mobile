import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowClusterPage extends StatefulWidget {
  final String clusterName;

  const ShowClusterPage({Key? key, required this.clusterName}) : super(key: key);

  @override
  _ShowClusterPageState createState() => _ShowClusterPageState();
}

class _ShowClusterPageState extends State<ShowClusterPage> {
  List<dynamic> menuItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClusterMenus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.clusterName} Menu'),
      ),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
    );
  },
)
,
    );
  }
}
