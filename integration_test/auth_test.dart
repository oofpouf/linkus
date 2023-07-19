import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:linkus/view/auth/register_view.dart';
import 'package:linkus/view/auth/verify_email_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('register view test', () {
    testWidgets('Weak password dialogue appears', (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'p');

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('weak_password')), findsOneWidget);
    });

    testWidgets('Email already in use dialogue appears', (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'linkusrandc@gmail.com');
      await tester.enterText(find.byKey(const Key('password_field')), '123456');

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('email_used')), findsOneWidget);
    });

    testWidgets('Invalid email dialogue appears', (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('email_field')), 'test');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password');

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('invalid_email')), findsOneWidget);
    });

    testWidgets('Registering navigates to verify email view', (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password');

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      expect(find.byType(VerifyEmailView), findsOneWidget);
    });
  });
}
