import 'package:flutter/material.dart';
import 'views/inhouse_sales_page.dart';
import 'views/delivery_sales_page.dart';
import 'views/summary_page.dart';
import 'views/staff_management_page.dart';
import 'views/attendance_page.dart';
import 'views/delivery_history_page.dart';
import 'views/wage_summary_page.dart';
import 'views/inhouse_sales_history_page.dart';
import 'views/inhouse_sales_export_page.dart';
import 'views/inhouse_sales_summary_page.dart'; // ✅ ADD this import
import 'views/delivery_sales_summary_page.dart';
import 'views/delivery_sales_export_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aroma Cafe Dashboard')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InhouseSalesPage()),
                ),
                child: const Text('In-House Sales'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InhouseSalesHistoryPage(),
                  ),
                ),
                child: const Text('In-House Sales History'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InhouseSalesSummaryPage(),
                  ),
                ),
                child: const Text('In-House Sales Summary'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InhouseSalesExportPage(),
                  ),
                ),
                child: const Text('Export In-House Sales'),
              ),
              const Divider(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeliverySalesPage()),
                ),
                child: const Text('Delivery Sales'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeliveryHistoryPage(),
                  ),
                ),
                child: const Text('Delivery History'),
              ),
              const Divider(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SummaryPage()),
                ),
                child: const Text('Summary'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WageSummaryPage()),
                ),
                child: const Text('Wage Summary'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AttendancePage()),
                ),
                child: const Text('Attendance'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StaffManagementPage(),
                  ),
                ),
                child: const Text('Manage Staff'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeliverySalesSummaryPage(),
                  ),
                ),
                child: const Text('Delivery Sales Summary'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeliverySalesExportPage(),
                  ),
                ),
                child: const Text('Export Delivery Sales'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
