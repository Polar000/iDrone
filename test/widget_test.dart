import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:idrone/main.dart';
import 'package:idrone/data/repositories/app_store.dart';

void main() {
  testWidgets('iDroneApp renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppStore(),
        child: const IDroneApp(),
      ),
    );

    expect(find.text('iDRONE'), findsWidgets);
  });
}
