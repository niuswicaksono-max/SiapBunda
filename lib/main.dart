import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'services/auth_service.dart';
import 'theme.dart';

void main() {
  runApp(const SiapBundaApp());
}

class SiapBundaApp extends StatelessWidget {
  const SiapBundaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siap Bunda',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const AuthGate(),
    );
  }
}

/// Mengecek apakah sudah ada sesi login: kalau ada ke Home, kalau tidak ke Login.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<UserAccount?> _future = AuthService().currentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserAccount?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        return user == null ? const LoginPage() : HomePage(user: user);
      },
    );
  }
}
