import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../services/db_service.dart';

class AttendanceReportPage extends StatelessWidget {
  const AttendanceReportPage({super.key});

  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();
    final attendanceList = await DBService().getAllAttendance();
    final staff = await DBService().getAllStaff();
    final staffMap = {for (var s in staff) s.id!: s.name};

    // Group by staff ID
    final grouped = <int, List<AttendanceModel>>{};
    for (var att in attendanceList) {
      grouped.putIfAbsent(att.staffId, () => []).add(att);
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Staff Attendance Report',
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
              headers: ['Date', 'Check In', 'Check Out', 'Duration'],
              data: entry.value.map((a) {
                return [
                  a.date,
                  a.checkInTime,
                  a.checkOutTime ?? '-',
                  a.duration ?? '-',
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
            pw.SizedBox(height: 20),
          ],
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/attendance_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    await OpenFilex.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attendance PDF saved: ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance PDF Report')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generate Attendance Report'),
          onPressed: () => _generatePDF(context),
        ),
      ),
    );
  }
}
