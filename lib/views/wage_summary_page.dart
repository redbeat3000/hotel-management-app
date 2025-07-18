import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../services/db_service.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../models/delivery_model.dart';

class WageSummaryPage extends StatefulWidget {
  const WageSummaryPage({super.key});

  @override
  State<WageSummaryPage> createState() => _WageSummaryPageState();
}

class _WageSummaryPageState extends State<WageSummaryPage> {
  List<UserModel> _staff = [];
  List<AttendanceModel> _attendance = [];
  List<DeliveryModel> _deliveries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final staff = await DBService().getAllStaff();
    final att = await DBService().getAllAttendance();
    final del = await DBService().getAllDeliveries();

    setState(() {
      _staff = staff;
      _attendance = att;
      _deliveries = del;
    });
  }

  int _daysPresent(int staffId) {
    return _attendance
        .where((a) => a.staffId == staffId)
        .map((a) => a.date)
        .toSet()
        .length;
  }

  double _deliveryCommission(int staffId) {
    return _deliveries
        .where((d) => d.staffId == staffId)
        .fold(0.0, (sum, d) => sum + d.commission);
  }

  double _calculatePay(UserModel user, int days) {
    if (user.paymentType == 'wage') {
      return days * user.dailyRate;
    } else {
      return user.monthlySalary;
    }
  }

  Future<void> _exportToPDF() async {
    final pdf = pw.Document();
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Wage Summary Report', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),
          pw.Text('Date: $date'),
          pw.Table.fromTextArray(
            headers: ['Name', 'Days', 'Base Pay', 'Commission', 'Total'],
            data: _staff.map((user) {
              final days = _daysPresent(user.id!);
              final base = _calculatePay(user, days);
              final commission = _deliveryCommission(user.id!);
              final total = base + commission;

              return [
                user.name,
                '$days',
                'KES ${base.toStringAsFixed(0)}',
                'KES ${commission.toStringAsFixed(0)}',
                'KES ${total.toStringAsFixed(0)}',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/wage_summary_$date.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Wage_Summary_$date.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wage Summary')),
      body: _staff.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _staff.length,
                    itemBuilder: (context, index) {
                      final user = _staff[index];
                      final days = _daysPresent(user.id!);
                      final base = _calculatePay(user, days);
                      final commission = _deliveryCommission(user.id!);
                      final total = base + commission;

                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(
                          '${user.paymentType.toUpperCase()} | Days Present: $days',
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Base: KES ${base.toStringAsFixed(0)}'),
                            Text('Comm: KES ${commission.toStringAsFixed(0)}'),
                            Text(
                              'Total: KES ${total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    onPressed: _exportToPDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export PDF'),
                  ),
                ),
              ],
            ),
    );
  }
}
