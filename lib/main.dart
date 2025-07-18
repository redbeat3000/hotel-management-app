import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/login_page.dart';
import 'views/register_admin_page.dart';
import 'services/db_service.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aroma Cafe',
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: const InitialScreen(), // 👈 key change
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isChecking = true;
  bool _adminExists = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await DBService().getAdminUser();
    setState(() {
      _adminExists = admin != null;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _adminExists ? const LoginPage() : const RegisterAdminPage();
  }
}
