import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorizer/pages/audio_page.dart' as audio;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memorizer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end', () {
    testWidgets('type text', (widgetTester) async {
      //app.main();
      //await widgetTester.pumpAndSettle();
      final field = find.byType(TextField);
      expect(field, findsOneWidget);
      widgetTester.enterText(field, 'Hello');
      await widgetTester.pump();
      expect(find.text('Hello'), findsOneWidget);
      //expect(find.text('Picked File Name:'), findsOneWidget);
    });
  });
}


