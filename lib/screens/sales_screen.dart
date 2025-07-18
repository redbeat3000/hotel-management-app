import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sales_provider.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isDelivery = false;

  void _submitSale() {
    final itemName = _itemNameController.text;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (itemName.isEmpty || quantity <= 0 || price <= 0.0) return;

    ref
        .read(salesProvider.notifier)
        .addSale(itemName, quantity, price, _isDelivery);

    _itemNameController.clear();
    _quantityController.clear();
    _priceController.clear();
    setState(() {
      _isDelivery = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sales = ref.watch(salesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Aroma Cafe - Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price per Item'),
            ),
            SwitchListTile(
              title: const Text('Delivery Sale?'),
              value: _isDelivery,
              onChanged: (val) => setState(() => _isDelivery = val),
            ),
            ElevatedButton(
              onPressed: _submitSale,
              child: const Text('Add Sale'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sales List:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sales.length,
                itemBuilder: (ctx, i) {
                  final s = sales[i];
                  return ListTile(
                    title: Text('${s.itemName} x${s.quantity}'),
                    subtitle: Text(s.isDelivery ? 'Delivery' : 'In-house'),
                    trailing: Text(
                      'KES ${(s.price * s.quantity).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
