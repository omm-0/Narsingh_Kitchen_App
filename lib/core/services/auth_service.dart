import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _keyRole = 'user_role';

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRole);
  }
}
