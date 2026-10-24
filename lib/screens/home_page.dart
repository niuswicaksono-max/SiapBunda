import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/auth_layout.dart';
import '../widgets/week_ring.dart';
import 'login_page.dart';
import 'register_page.dart' show formatTanggal;

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.user});

  final UserAccount user;

  /// Minggu kehamilan berdasarkan HPL (kehamilan = 280 hari).
  int? get _week {
    final due = user.dueDate;
    if (due == null) return null;
    final today = DateTime.now();
    final daysLeft = DateTime(due.year, due.month, due.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    return ((280 - daysLeft) / 7).floor().clamp(0, 40);
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final week = _week;
    final firstName = user.name.split(' ').first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPaper,
        elevation: 0,
        title: const LogoMark(),
        actions: [
          TextButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Keluar'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Text(
                  'Halo, $firstName',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(user.roleLabel, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 32),
                WeekRing(
                  filled: week ?? 0,
                  size: 280,
                  onColor: kCoral,
                  offColor: kLilac,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        week == null ? '–' : '$week',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        week == null ? 'HPL belum diisi' : 'dari 40 minggu',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (user.dueDate != null)
                  Text(
                    'Perkiraan lahir: ${formatTanggal(user.dueDate!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 32),
                const Text(
                  'Fitur berikutnya (jadwal kontrol, checklist persalinan, '
                  'jurnal) akan ditambahkan di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
