import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/auth_layout.dart';
import 'home_page.dart';

const List<String> kBulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String formatTanggal(DateTime d) => '${d.day} ${kBulan[d.month - 1]} ${d.year}';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _dueDateText = TextEditingController();
  final _auth = AuthService();

  String _role = 'ibu';
  DateTime? _dueDate;
  bool _hidePassword = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _dueDateText.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 140)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 300)),
      helpText: 'Pilih perkiraan hari lahir',
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateText.text = formatTanggal(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _auth.register(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      role: _role,
      dueDate: _dueDate,
    );
    if (!mounted) return;

    if (result.ok) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage(user: result.user!)),
        (route) => false,
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
              'Buat akun',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Daftar untuk mulai mencatat kehamilan dan persiapan persalinan.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 28),
            if (_error != null) ...[
              AuthErrorBanner(message: _error!),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'ibu',
                    label: Text('Calon ibu'),
                    icon: Icon(Icons.pregnant_woman),
                  ),
                  ButtonSegment(
                    value: 'ayah',
                    label: Text('Calon ayah'),
                    icon: Icon(Icons.man),
                  ),
                ],
                selected: {_role},
                onSelectionChanged: (s) => setState(() => _role = s.first),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Nama wajib diisi';
                if (value.length < 3) return 'Nama minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
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
              controller: _dueDateText,
              readOnly: true,
              onTap: _pickDueDate,
              decoration: InputDecoration(
                labelText: 'Perkiraan hari lahir (opsional)',
                prefixIcon: const Icon(Icons.event_outlined),
                suffixIcon: _dueDate == null
                    ? null
                    : IconButton(
                        tooltip: 'Hapus tanggal',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() {
                          _dueDate = null;
                          _dueDateText.clear();
                        }),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: _hidePassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Kata sandi',
                helperText: 'Minimal 8 karakter, berisi huruf dan angka',
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
              validator: (v) {
                final value = v ?? '';
                if (value.isEmpty) return 'Kata sandi wajib diisi';
                if (value.length < 8) return 'Minimal 8 karakter';
                final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
                final hasDigit = RegExp(r'\d').hasMatch(value);
                if (!hasLetter || !hasDigit) return 'Harus berisi huruf dan angka';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirm,
              obscureText: _hidePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Ulangi kata sandi',
                prefixIcon: Icon(Icons.lock_reset_outlined),
              ),
              validator: (v) =>
                  v == _password.text ? null : 'Kata sandi tidak sama',
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
                  : const Text('Daftar'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah punya akun?'),
                TextButton(
                  onPressed:
                      _loading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Masuk'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
