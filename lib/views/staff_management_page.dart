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

    final newStaff = UserModel(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photoPath: _selectedPhoto?.path ?? '',
      password: '',
      username: null,
      role: 'staff',
      lastLogin: '',
    );

    await DBService().insertUser(newStaff);

    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    setState(() => _selectedPhoto = null);

    await _loadStaff();
  }

  void _editStaffDialog(UserModel staff) {
    final nameCtrl = TextEditingController(text: staff.name);
    final phoneCtrl = TextEditingController(text: staff.phone);
    final emailCtrl = TextEditingController(text: staff.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Staff'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updated = staff.copyWith(
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                );
                await DBService().updateUser(updated);
                Navigator.pop(context);
                await _loadStaff();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Staff'),
          content: const Text(
            'Are you sure you want to delete this staff member?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final db = await DBService().database;
                await db.delete('users', where: 'id = ?', whereArgs: [id]);
                Navigator.pop(context);
                await _loadStaff();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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
                    subtitle: Text(staff.phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editStaffDialog(staff),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(staff.id!),
                        ),
                      ],
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
