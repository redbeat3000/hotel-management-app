import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sales_provider.dart';
import '../models/sale.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(salesProvider);

    final totalInhouse = sales
        .where((s) => !s.isDelivery)
        .fold<double>(0, (sum, s) => sum + (s.price * s.quantity));
    final totalDelivery = sales
        .where((s) => s.isDelivery)
        .fold<double>(0, (sum, s) => sum + (s.price * s.quantity));
    final totalSales = totalInhouse + totalDelivery;

    return Scaffold(
      appBar: AppBar(title: const Text('Sales Summary')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryTile(label: 'In-House Sales:', amount: totalInhouse),
            SummaryTile(label: 'Delivery Sales:', amount: totalDelivery),
            const Divider(),
            SummaryTile(
              label: 'Total Sales:',
              amount: totalSales,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const SummaryTile({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$label KES ${amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: isTotal ? 20 : 16,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
