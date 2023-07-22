// check if match appears
// check that removing removes the match

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:linkus/services/auth/auth_service.dart';
import 'package:linkus/view/match_history_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();

    // log into existing account
    await AuthService.firebase().logIn(
      email: 'linkusrandc@gmail.com',
      password: '123456',
    );
  });

  group('Match history test ', () {
    testWidgets('Matches appear in history', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MatchHistoryView(),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('puppy'), findsOneWidget);
      expect(find.text('Tele ID: @puppy'), findsOneWidget);
    });

    testWidgets('Remove matches in history', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MatchHistoryView(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('puppy'), findsNothing);
      expect(find.text('Tele ID: @puppy'), findsNothing);
    });
  });
}
