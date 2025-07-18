import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/inhouse_sale_model.dart';
import '../services/db_service.dart';

class InhouseSalesExportPage extends StatefulWidget {
  const InhouseSalesExportPage({super.key});

  @override
  State<InhouseSalesExportPage> createState() => _InhouseSalesExportPageState();
}

class _InhouseSalesExportPageState extends State<InhouseSalesExportPage> {
  List<InhouseSaleModel> _sales = [];

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final sales = await DBService().getAllInhouseSales();
    setState(() => _sales = sales);
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Aroma Cafe - In-House Sales Report',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Date: $date\n\n'),

          pw.Table.fromTextArray(
            headers: ['Item', 'Quantity', 'Unit Price', 'Total', 'Date'],
            data: _sales.map((s) {
              final total = (s.quantity * s.unitPrice).toStringAsFixed(2);
              return [s.item, s.quantity, s.unitPrice, total, s.date];
            }).toList(),
          ),

          pw.SizedBox(height: 20),
          pw.Text(
            'Total Sales: Ksh ${_sales.fold<double>(0, (sum, s) => sum + (s.unitPrice * s.quantity)).toStringAsFixed(2)}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
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
      appBar: AppBar(title: const Text('Export In-House Sales')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _exportToPdf,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generate & Export PDF'),
        ),
      ),
    );
  }
}
