import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import '../models/user_model.dart';
import '../models/delivery_model.dart';
import '../services/db_service.dart';

class DeliveryReportPage extends StatelessWidget {
  const DeliveryReportPage({super.key});

  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();
    final deliveries = await DBService().getAllDeliveries();
    final staff = await DBService().getAllStaff();
    final staffMap = {for (var s in staff) s.id!: s.name};

    // Group by staff
    final grouped = <int, List<DeliveryModel>>{};
    for (var d in deliveries) {
      grouped.putIfAbsent(d.staffId, () => []).add(d);
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Delivery Sales Report',
              style: pw.TextStyle(fontSize: 24),
            ),
          ),
          for (var entry in grouped.entries) ...[
            pw.Text(
              'Staff: ${staffMap[entry.key] ?? 'Unknown'}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Table.fromTextArray(
              headers: ['Item', 'Qty', 'Price', 'Total', 'Commission', 'Date'],
              data: entry.value.map((d) {
                return [
                  d.item,
                  d.quantity.toString(),
                  d.price.toStringAsFixed(2),
                  d.total.toStringAsFixed(2),
                  d.commission.toStringAsFixed(2),
                  d.date,
                ];
              }).toList(),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
            ),
            pw.Divider(),
            pw.Text(
              'Total Sales: KES ${entry.value.fold(0, (sum, d) => sum + d.total).toStringAsFixed(2)}',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              'Total Commissions: KES ${entry.value.fold(0, (sum, d) => sum + d.commission).toStringAsFixed(2)}',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 20),
          ],
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/delivery_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    // Open the file
    await OpenFilex.open(file.path);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PDF saved to: ${file.path}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery PDF Report')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generate PDF Report'),
          onPressed: () => _generatePDF(context),
        ),
      ),
    );
  }
}
