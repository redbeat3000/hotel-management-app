import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';
import 'login_page.dart';

class RegisterAdminPage extends StatefulWidget {
  const RegisterAdminPage({Key? key}) : super(key: key);

  @override
  State<RegisterAdminPage> createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _registerAdmin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final existingAdmin = await DBService().getAdminUser();
    if (existingAdmin != null) {
      setState(() {
        _error = 'An admin already exists. Please log in.';
        _isLoading = false;
      });
      return;
    }

    final admin = UserModel(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photoPath: '', // set later
      password: _passwordController.text.trim(),
      role: 'admin',
      lastLogin: '',
    );

    await DBService().insertUser(admin);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Admin')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter username' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _registerAdmin();
                        }
                      },
                      child: const Text('Create Admin'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
