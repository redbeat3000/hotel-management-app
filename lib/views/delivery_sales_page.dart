import 'package:flutter/material.dart';
import '../models/delivery_model.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';

class DeliverySalesPage extends StatefulWidget {
  const DeliverySalesPage({Key? key}) : super(key: key);

  @override
  State<DeliverySalesPage> createState() => _DeliverySalesPageState();
}

class _DeliverySalesPageState extends State<DeliverySalesPage> {
  final _itemController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _commissionController = TextEditingController(text: '10');

  String _paymentType = 'M-Pesa';
  double _total = 0.0;
  double _commission = 0.0;

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
    });
  }

  void _calculateTotals() {
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    final rate = double.tryParse(_commissionController.text.trim()) ?? 10;

    _total = qty * price;
    _commission = _total * (rate / 100);
    setState(() {});
  }

  Future<void> _saveDelivery() async {
    if (_itemController.text.isEmpty || _selectedStaff == null) return;

    final qty = int.tryParse(_qtyController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    final rate = double.tryParse(_commissionController.text.trim()) ?? 10;
    final total = qty * price;
    final commission = total * (rate / 100);

    final delivery = DeliveryModel(
      item: _itemController.text.trim(),
      quantity: qty,
      price: price,
      total: total,
      paymentType: _paymentType,
      staffId: _selectedStaff!.id!,
      commission: commission,
      date: DateTime.now().toString().substring(0, 10),
    );

    await DBService().insertDelivery(delivery);

    _itemController.clear();
    _qtyController.clear();
    _priceController.clear();
    _commissionController.text = '10';
    _selectedStaff = null;
    _total = 0;
    _commission = 0;

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delivery saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Sales')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Delivery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _itemController,
              decoration: const InputDecoration(labelText: 'Item'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
              onChanged: (_) => _calculateTotals(),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price per Item'),
              onChanged: (_) => _calculateTotals(),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _commissionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Commission %'),
              onChanged: (_) => _calculateTotals(),
            ),
            const SizedBox(height: 10),

            DropdownButton<String>(
              value: _paymentType,
              isExpanded: true,
              items: ['M-Pesa', 'Cash'].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (val) => setState(() => _paymentType = val!),
            ),
            const SizedBox(height: 10),

            DropdownButton<UserModel>(
              value: _selectedStaff,
              hint: const Text('Select Delivery Staff'),
              isExpanded: true,
              items: _staffList.map((staff) {
                return DropdownMenuItem(value: staff, child: Text(staff.name));
              }).toList(),
              onChanged: (val) => setState(() => _selectedStaff = val),
            ),
            const SizedBox(height: 20),

            Text('Total: KES $_total', style: const TextStyle(fontSize: 16)),
            Text(
              'Commission: KES $_commission',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveDelivery,
              child: const Text('Save Delivery'),
            ),
          ],
        ),
      ),
    );
  }
}
