// check if same degree appears, with match alr swiped yes
// check if same hobby appears
// check if swiping yes will register its a match
// going back to match history will navigate
// check if match appears in history
// check if deleting removes the match

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/placeholders/cardstackwidget.dart';
import 'package:linkus/services/auth/auth_service.dart';
import 'package:linkus/utilities/my_navigation_bar.dart';
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

  group('Cardstack Widget test', () {
    testWidgets('Same hobby appears on cardstack', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CardsStackWidget(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('bunny'), findsOneWidget);
      expect(find.text('arts and crafts'), findsOneWidget);
    });

    testWidgets('Same degree appears on cardstack', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CardsStackWidget(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // bunny removed from card stack
      await tester.tap(find.byIcon(Icons.close));

      // puppy expected to be found
      expect(find.text('puppy'), findsOneWidget);
      expect(find.text('business analytics'), findsOneWidget);
    });

      testWidgets("It's a match dialog appears", (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CardsStackWidget(),
          ),
        );
        await tester.pumpAndSettle();

        // bunny removed from card stack
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // click like on puppy
        await tester.tap(find.byIcon(Icons.favorite));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        expect(find.byKey(const Key('link_dialog')), findsOneWidget);
      });

      testWidgets('Returns to link history', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            routes: {
              matchHistoryRoute: (context) => const MyNavigationBar(index: 0),
            },
            home: const CardsStackWidget(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('return_button')));
        await tester.pumpAndSettle(const Duration(seconds: 10));

        expect(find.byType(MatchHistoryView), findsOneWidget);
      });
  });
}
