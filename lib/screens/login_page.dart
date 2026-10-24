import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/auth_layout.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();

  bool _hidePassword = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _auth.login(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;

    if (result.ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(user: result.user!)),
      );
    } else {
      setState(() {
        _loading = false;
        _error = result.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masuk',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selamat datang kembali. Lanjutkan perjalanan kehamilanmu.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 28),
            if (_error != null) ...[
              AuthErrorBanner(message: _error!),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Email wajib diisi';
                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                return ok ? null : 'Format email belum benar';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: _hidePassword,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Kata sandi',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip: _hidePassword ? 'Tampilkan' : 'Sembunyikan',
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
              ),
              validator: (v) =>
                  (v ?? '').isEmpty ? 'Kata sandi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Masuk'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum punya akun?'),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          ),
                  child: const Text('Daftar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
