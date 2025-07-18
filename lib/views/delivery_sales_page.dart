import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../providers/sales_provider.dart';
import '../services/db_service.dart';

class DeliverySalesPage extends ConsumerStatefulWidget {
  const DeliverySalesPage({super.key});

  @override
  ConsumerState<DeliverySalesPage> createState() => _DeliverySalesPageState();
}

class _DeliverySalesPageState extends ConsumerState<DeliverySalesPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  List<UserModel> _staffList = [];
  UserModel? _selectedStaff;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staff = await DBService().getAllStaff();
    setState(() {
      _staffList = staff;
      if (_staffList.isNotEmpty) {
        _selectedStaff = _staffList.first;
      }
    });
  }

  void _submitSale() {
    if (_formKey.currentState!.validate() && _selectedStaff != null) {
      final item = _itemController.text.trim();
      final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      ref
          .read(salesProvider.notifier)
          .addSale(item, quantity, price, true, staffId: _selectedStaff!.id!);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Delivery sale recorded')));

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
      appBar: AppBar(title: const Text('Delivery Sales')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<UserModel>(
                value: _selectedStaff,
                items: _staffList.map((staff) {
                  return DropdownMenuItem(
                    value: staff,
                    child: Text(staff.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedStaff = val),
                decoration: const InputDecoration(labelText: 'Delivery Staff'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Unit Price'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitSale,
                child: const Text('Submit Delivery Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
