import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sales_provider.dart';

class InhouseSalesPage extends ConsumerStatefulWidget {
  const InhouseSalesPage({super.key});

  @override
  ConsumerState<InhouseSalesPage> createState() => _InhouseSalesPageState();
}

class _InhouseSalesPageState extends ConsumerState<InhouseSalesPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  void _submitSale() {
    if (_formKey.currentState!.validate()) {
      final itemName = _itemController.text.trim();
      final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      ref
          .read(salesProvider.notifier)
          .addSale(itemName, quantity, price, false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sale added successfully!')));

      _itemController.clear();
      _quantityController.clear();
      _priceController.clear();
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('In-House Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitSale,
                child: const Text('Add Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
