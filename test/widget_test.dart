import 'package:flutter_test/flutter_test.dart';

import 'package:app1/main.dart';

void main() {
  testWidgets('Halaman daftar menu tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Kantin Bu Sari'), findsWidgets);
    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
  });
}
