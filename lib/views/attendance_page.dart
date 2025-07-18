import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../services/db_service.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<UserModel> _staffList = [];
  List<AttendanceModel> _attendanceList = [];
  UserModel? _selectedStaff;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final staff = await DBService().getAllStaff();
    final today = DateTime.now().toString().substring(0, 10);
    final records = await DBService().getAttendanceByDate(today);
    setState(() {
      _staffList = staff;
      _attendanceList = records;
    });
  }

  Future<void> _checkIn() async {
    if (_selectedStaff == null) return;

    final now = DateTime.now();
    final today = now.toString().substring(0, 10);

    final att = AttendanceModel(
      staffId: _selectedStaff!.id!,
      checkInTime: now.toIso8601String(),
      checkOutTime: '',
      duration: '',
      date: today,
    );

    await DBService().insertAttendance(att);
    _selectedStaff = null;
    await _loadData();
  }

  Future<void> _checkOut(AttendanceModel record) async {
    final now = DateTime.now();
    final checkIn = DateTime.parse(record.checkInTime);
    final duration = now.difference(checkIn).inMinutes;

    final updated = AttendanceModel(
      id: record.id,
      staffId: record.staffId,
      checkInTime: record.checkInTime,
      checkOutTime: now.toIso8601String(),
      duration: '$duration minutes',
      date: record.date,
    );

    final db = await DBService().database;
    await db.update(
      'attendance',
      updated.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
    await _loadData();
  }

  String _staffNameById(int id) {
    final staff = _staffList.firstWhere(
      (s) => s.id == id,
      orElse: () => UserModel(
        id: 0,
        name: 'Unknown',
        phone: '',
        email: '',
        photoPath: '',
        password: '',
        role: 'staff',
        lastLogin: '',
      ),
    );
    return staff.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<UserModel>(
              hint: const Text('Select Staff'),
              value: _selectedStaff,
              isExpanded: true,
              items: _staffList.map((staff) {
                return DropdownMenuItem(value: staff, child: Text(staff.name));
              }).toList(),
              onChanged: (val) => setState(() => _selectedStaff = val),
            ),
            ElevatedButton(onPressed: _checkIn, child: const Text('Check In')),
            const Divider(height: 30),
            const Text('Today\'s Attendance', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _attendanceList.length,
                itemBuilder: (context, index) {
                  final record = _attendanceList[index];
                  return ListTile(
                    title: Text(_staffNameById(record.staffId)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check In: ${record.checkInTime.substring(11, 16)}',
                        ),
                        Text(
                          record.checkOutTime.isNotEmpty
                              ? 'Check Out: ${record.checkOutTime.substring(11, 16)}'
                              : 'Still working...',
                        ),
                        if (record.duration.isNotEmpty)
                          Text('Duration: ${record.duration}'),
                      ],
                    ),
                    trailing: record.checkOutTime.isEmpty
                        ? IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () => _checkOut(record),
                          )
                        : const Icon(Icons.check, color: Colors.green),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
