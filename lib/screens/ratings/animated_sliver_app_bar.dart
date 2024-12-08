import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: false,
      centerTitle: true,
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Ratings',
        style: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
