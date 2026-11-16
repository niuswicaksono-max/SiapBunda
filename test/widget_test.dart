import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:siap_bunda/main.dart';

void main() {
  testWidgets('membuka halaman masuk saat belum login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SiapBundaApp());
    await tester.pumpAndSettle();

    expect(find.text('Masuk'), findsWidgets);
    expect(find.text('Daftar'), findsOneWidget);
  });
}
