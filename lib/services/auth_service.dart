import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _usersKey = 'efish_users';

  static Future<Map<String, String>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_usersKey) ?? '{}';
    final Map<String, dynamic> map = json.decode(jsonStr);
    return map.map((k, v) => MapEntry(k, v as String));
  }

  static Future<void> _saveUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(users));
  }

  static Future<bool> register(String email, String password) async {
    final users = await _getUsers();
    if (users.containsKey(email)) return false;
    users[email] = password;
    await _saveUsers(users);
    print('✅ User terdaftar: $users');
    return true;
  }

  static Future<bool> login(String email, String password) async {
    final users = await _getUsers();
    return users[email] == password;
  }

  static Future<bool> resetPassword(String email, String newPassword) async {
    final users = await _getUsers();
    if (!users.containsKey(email)) return false;
    users[email] = newPassword;
    await _saveUsers(users);
    print('🔁 Password direset: $users');
    return true;
  }
}
