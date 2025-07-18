import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';

final authProvider = StateNotifierProvider<AuthController, UserModel?>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<UserModel?> {
  AuthController() : super(null);

  final DBService _dbService = DBService();

  Future<bool> loginAdmin(String username, String password) async {
    final user = await _dbService.loginAdmin(username, password);
    if (user != null) {
      state = user;
      return true;
    }
    return false;
  }

  void logout() {
    state = null;
  }

  bool get isLoggedIn => state != null && state!.role == 'admin';

  UserModel? get currentUser => state;
}
