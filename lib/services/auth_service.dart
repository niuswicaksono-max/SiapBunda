import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount {
  const UserAccount({
    required this.name,
    required this.email,
    required this.role,
    this.dueDate,
  });

  final String name;
  final String email;

  /// 'ibu' atau 'ayah'
  final String role;

  /// Hari perkiraan lahir (HPL), boleh kosong.
  final DateTime? dueDate;

  String get roleLabel => role == 'ayah' ? 'Calon ayah' : 'Calon ibu';

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'role': role,
        'dueDate': dueDate?.toIso8601String(),
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    final due = json['dueDate'] as String?;
    return UserAccount(
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      dueDate: due == null ? null : DateTime.parse(due),
    );
  }
}

class AuthResult {
  const AuthResult.success(this.user)
      : ok = true,
        message = null;
  const AuthResult.failure(this.message)
      : ok = false,
        user = null;

  final bool ok;
  final String? message;
  final UserAccount? user;
}

/// Autentikasi LOKAL untuk tahap awal (data disimpan di browser/perangkat).
/// Saat backend siap, ganti isi register/login/currentUser/logout dengan
/// pemanggilan API atau Firebase Auth. Tampilan tidak perlu diubah.
class AuthService {
  static const _usersKey = 'siap_bunda_users';
  static const _sessionKey = 'siap_bunda_session';

  String _hash(String email, String password) {
    return sha256.convert(utf8.encode('$email:$password')).toString();
  }

  Future<Map<String, dynamic>> _readUsers(SharedPreferences prefs) async {
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String role,
    DateTime? dueDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final prefs = await SharedPreferences.getInstance();
    final users = await _readUsers(prefs);
    final key = email.trim().toLowerCase();

    if (users.containsKey(key)) {
      return const AuthResult.failure(
        'Email ini sudah terdaftar. Silakan masuk.',
      );
    }

    final user = UserAccount(
      name: name.trim(),
      email: key,
      role: role,
      dueDate: dueDate,
    );
    users[key] = {...user.toJson(), 'hash': _hash(key, password)};
    await prefs.setString(_usersKey, jsonEncode(users));
    await prefs.setString(_sessionKey, key);
    return AuthResult.success(user);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final prefs = await SharedPreferences.getInstance();
    final users = await _readUsers(prefs);
    final key = email.trim().toLowerCase();
    final data = users[key] as Map<String, dynamic>?;

    if (data == null || data['hash'] != _hash(key, password)) {
      return const AuthResult.failure('Email atau kata sandi salah.');
    }

    await prefs.setString(_sessionKey, key);
    return AuthResult.success(UserAccount.fromJson(data));
  }

  Future<UserAccount?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_sessionKey);
    if (key == null) return null;
    final users = await _readUsers(prefs);
    final data = users[key] as Map<String, dynamic>?;
    return data == null ? null : UserAccount.fromJson(data);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
