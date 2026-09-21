import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:idrone/main.dart';
import 'package:idrone/data/repositories/app_store.dart';

void main() {
  testWidgets('iDrone App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppStore(),
        child: const IDroneApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify main screen components load
    expect(find.text('Tu campo, en buenas manos'), findsOneWidget);
  });
}
