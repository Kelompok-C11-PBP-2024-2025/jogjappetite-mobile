import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/screens/search/search_functions.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String, CookieRequest, BuildContext) onSearchFood;
  final Function(String, CookieRequest, BuildContext) onSearchRestaurant;
  final Function(String, CookieRequest) onSaveSearchHistory;

  SearchAppBar({
    required this.searchController,
    required this.onSearchFood,
    required this.onSearchRestaurant,
    required this.onSaveSearchHistory,
  });

  @override
  _SearchBar createState() => _SearchBar();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchBar extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.fastfood,
                    color: Colors.black54,
                  ),
                  onPressed: () async {
                    String query = widget.searchController.text;
                    await widget.onSaveSearchHistory(query, request);
                    await widget.onSearchFood(query, request, context);
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.restaurant,
                  color: Colors.black54,
                ),
                onPressed: () async {
                  String query = widget.searchController.text;
                  await widget.onSaveSearchHistory(query, request);
                  await widget.onSearchRestaurant(query, request, context);
                },
              ),
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search restaurants or food',
                    hintStyle: TextStyle(
                      color: Colors.black45,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.black54,
                ),
                onPressed: () {
                  widget.searchController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}