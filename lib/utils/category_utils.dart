library category_utils;

import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/explore/show_cluster.dart';

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

void navigateToCluster(BuildContext context, String category) {
  final String clusterKey = clusterMapping[category] ?? category.toLowerCase();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ShowClusterPage(
        clusterName: clusterKey,
      ),
    ),
  );
}