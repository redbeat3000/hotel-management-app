import 'package:flutter/material.dart';
import '../models/delivery_model.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';

class DeliveryHistoryPage extends StatefulWidget {
  const DeliveryHistoryPage({super.key});

  @override
  State<DeliveryHistoryPage> createState() => _DeliveryHistoryPageState();
}

class _DeliveryHistoryPageState extends State<DeliveryHistoryPage> {
  List<DeliveryModel> _deliveries = [];
  Map<int, String> _staffNames = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final deliveries = await DBService().getAllDeliveries();
    final staff = await DBService().getAllStaff();

    final staffMap = {for (var s in staff) s.id!: s.name};

    setState(() {
      _deliveries = deliveries;
      _staffNames = staffMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery History')),
      body: _deliveries.isEmpty
          ? const Center(child: Text('No delivery records found.'))
          : ListView.builder(
              itemCount: _deliveries.length,
              itemBuilder: (context, index) {
                final d = _deliveries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      '${d.item} - KES ${d.total.toStringAsFixed(2)}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${d.quantity}, Price: ${d.price}'),
                        Text('Staff: ${_staffNames[d.staffId] ?? 'Unknown'}'),
                        Text(
                          'Commission: KES ${d.commission.toStringAsFixed(2)}',
                        ),
                        Text('Payment: ${d.paymentType}, Date: ${d.date}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
