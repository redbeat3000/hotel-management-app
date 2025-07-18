import '../views/inhouse_sales_page.dart';
import '../views/delivery_sales_page.dart';

import 'package:flutter/material.dart';
import 'sales_screen.dart'; // Make sure this file exists
// import other screens when ready

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aroma Cafe Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('In-House Sales'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delivery_dining),
            title: const Text('Delivery Sales'),
            onTap: () {
              // Add Delivery Screen navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reports'),
            onTap: () {
              // Add Reports Screen navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Add Settings Screen navigation
            },
          ),
        ],
      ),
    );
  }
}
