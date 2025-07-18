import 'views/inhouse_sales_summary_page.dart';

ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const InhouseSalesSummaryPage()),
  ),
  child: const Text('In-House Sales Summary'),
),
