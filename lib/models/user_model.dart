import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/user_model.dart';
import '../services/db_service.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({Key? key}) : super(key: key);

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  List<UserModel> _staffList = [];

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _rateController = TextEditingController();

  String _paymentType = 'wage'; // default value
  File? _selectedPhoto;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staff = await DBService().getAllStaff();
    setState(() {
      _staffList = staff;
    });
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(picked.path);
      final savedImage = await File(
        picked.path,
      ).copy('${appDir.path}/$fileName');
      setState(() {
        _selectedPhoto = savedImage;
      });
    }
  }

  Future<void> _addStaff() async {
    if (_nameController.text.isEmpty) return;

    final dailyRate = _paymentType == 'wage'
        ? double.tryParse(_rateController.text.trim()) ?? 0.0
        : 0.0;
    final monthlySalary = _paymentType == 'salary'
        ? double.tryParse(_rateController.text.trim()) ?? 0.0
        : 0.0;

    final newStaff = UserModel(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photoPath: _selectedPhoto?.path ?? '',
      password: '',
      username: null,
      role: 'staff',
      lastLogin: '',
      paymentType: _paymentType,
      dailyRate: dailyRate,
      monthlySalary: monthlySalary,
    );

    await DBService().insertUser(newStaff);

    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _rateController.clear();
    setState(() => _selectedPhoto = null);

    await _loadStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Staff')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Add New Staff', style: TextStyle(fontSize: 18)),

            // 📸 Photo Picker
            GestureDetector(
              onTap: _pickPhoto,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _selectedPhoto != null
                    ? FileImage(_selectedPhoto!)
                    : null,
                child: _selectedPhoto == null
                    ? const Icon(Icons.camera_alt, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 10),

            // 📝 Form Fields
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            // Payment Type
            DropdownButton<String>(
              value: _paymentType,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'wage', child: Text('Wage (per day)')),
                DropdownMenuItem(
                  value: 'salary',
                  child: Text('Salary (fixed monthly)'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _paymentType = val);
              },
            ),

            // Rate Input
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _paymentType == 'wage'
                    ? 'Daily Rate (KES)'
                    : 'Monthly Salary (KES)',
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addStaff,
              child: const Text('Add Staff'),
            ),

            const Divider(height: 30),

            const Text('All Staff', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _staffList.length,
                itemBuilder: (context, index) {
                  final staff = _staffList[index];
                  return ListTile(
                    leading: staff.photoPath.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(staff.photoPath)),
                          )
                        : const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(staff.name),
                    subtitle: Text('${staff.phone} (${staff.paymentType})'),
                    trailing: Text(
                      staff.paymentType == 'wage'
                          ? 'KES ${staff.dailyRate.toStringAsFixed(0)} /day'
                          : 'KES ${staff.monthlySalary.toStringAsFixed(0)} /mo',
                    ),
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
