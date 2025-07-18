import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../services/db_service.dart';
import '../models/delivery_sale_model.dart';

class DeliverySalesExportPage extends StatefulWidget {
  const DeliverySalesExportPage({super.key});

  @override
  State<DeliverySalesExportPage> createState() =>
      _DeliverySalesExportPageState();
}

class _DeliverySalesExportPageState extends State<DeliverySalesExportPage> {
  List<DeliverySaleModel> _sales = [];

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final sales = await DBService().getAllDeliverySales();
    setState(() => _sales = sales);
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Delivery Sales Report', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ['Date', 'Item', 'Qty', 'Price', 'Total'],
            data: _sales.map((sale) {
              final total = sale.quantity * sale.unitPrice;
              return [
                sale.date,
                sale.itemName,
                sale.quantity.toString(),
                'Ksh ${sale.unitPrice.toStringAsFixed(2)}',
                'Ksh ${total.toStringAsFixed(2)}',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Delivery Sales')),
      body: Center(
        child: ElevatedButton(
          onPressed: _sales.isEmpty ? null : _generatePdf,
          child: const Text('Generate PDF'),
        ),
      ),
    );
  }
}
