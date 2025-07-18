import 'package:flutter/material.dart';
import 'views/inhouse_sales_page.dart';
import 'views/delivery_sales_page.dart';
import 'views/summary_page.dart';
import 'views/staff_management_page.dart';
import 'views/attendance_page.dart';
import 'views/delivery_history_page.dart';
import 'views/wage_summary_page.dart'; // ✅ NEW

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aroma Cafe Dashboard')),
      body: Center(
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
                MaterialPageRoute(builder: (_) => const DeliverySalesPage()),
              ),
              child: const Text('Delivery Sales'),
            ),
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
                MaterialPageRoute(builder: (_) => const StaffManagementPage()),
              ),
              child: const Text('Manage Staff'),
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
                MaterialPageRoute(builder: (_) => const DeliveryHistoryPage()),
              ),
              child: const Text('Delivery History'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WageSummaryPage()),
              ),
              child: const Text('Wage Summary'),
            ),
          ],
        ),
      ),
    );
  }
}
