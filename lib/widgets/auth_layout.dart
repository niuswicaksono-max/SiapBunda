import 'package:flutter/material.dart';

import '../theme.dart';
import 'week_ring.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.light = false});

  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : kPlum;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: kCoral,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.child_friendly_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Siap Bunda',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPlum,
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LogoMark(light: true),
          const Spacer(),
          Center(
            child: WeekRing(
              filled: 28,
              size: 320,
              onColor: kCoral,
              offColor: Colors.white24,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '28',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'dari 40 minggu',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Sembilan bulan, satu minggu setiap kali.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Catat kehamilan, siapkan persalinan, dan bersiap menyambut '
            'si kecil bersama pasangan.',
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// Kerangka halaman login & register: dua kolom di layar lebar (Chrome),
/// satu kolom di layar sempit (HP).
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final form = Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!wide) ...[
                      const LogoMark(),
                      const SizedBox(height: 32),
                    ],
                    child,
                  ],
                ),
              ),
            ),
          );

          if (!wide) return SafeArea(child: form);

          return Row(
            children: [
              const Expanded(flex: 5, child: _BrandPanel()),
              Expanded(flex: 6, child: form),
            ],
          );
        },
      ),
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5B7B1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFC0392B), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF7B241C), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
