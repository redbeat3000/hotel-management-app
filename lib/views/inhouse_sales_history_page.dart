import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inhouse_sale_model.dart';
import '../services/db_service.dart';

class InhouseSalesHistoryPage extends StatefulWidget {
  const InhouseSalesHistoryPage({super.key});

  @override
  State<InhouseSalesHistoryPage> createState() =>
      _InhouseSalesHistoryPageState();
}

class _InhouseSalesHistoryPageState extends State<InhouseSalesHistoryPage> {
  List<InhouseSaleModel> _sales = [];
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales({String? date}) async {
    List<InhouseSaleModel> data;
    if (date != null) {
      data = await DBService().getInhouseSalesByDate(date);
    } else {
      data = await DBService().getAllInhouseSales();
    }
    setState(() => _sales = data);
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() => _selectedDate = formatted);
      _loadSales(date: formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In-House Sales History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
            tooltip: 'Filter by Date',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() => _selectedDate = null);
              _loadSales();
            },
            tooltip: 'Clear Filter',
          ),
        ],
      ),
      body: _sales.isEmpty
          ? const Center(child: Text('No sales found.'))
          : ListView.builder(
              itemCount: _sales.length,
              itemBuilder: (context, index) {
                final sale = _sales[index];
                final total = (sale.quantity * sale.unitPrice).toStringAsFixed(
                  2,
                );
                return ListTile(
                  title: Text('${sale.item} × ${sale.quantity}'),
                  subtitle: Text('Ksh $total'),
                  trailing: Text(sale.date),
                );
              },
            ),
    );
  }
}
