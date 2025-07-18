import 'package:flutter/material.dart';
import '../models/delivery_sale_model.dart';
import '../services/db_service.dart';

class DeliverySalesSummaryPage extends StatefulWidget {
  const DeliverySalesSummaryPage({super.key});

  @override
  State<DeliverySalesSummaryPage> createState() =>
      _DeliverySalesSummaryPageState();
}

class _DeliverySalesSummaryPageState extends State<DeliverySalesSummaryPage> {
  double totalRevenue = 0;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final sales = await DBService().getAllDeliverySales();
    double revenue = 0;
    int items = 0;

    for (var sale in sales) {
      revenue += sale.unitPrice * sale.quantity;
      items += sale.quantity;
    }

    setState(() {
      totalRevenue = revenue;
      totalItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Sales Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Revenue: Ksh ${totalRevenue.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Total Items Delivered: $totalItems',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
