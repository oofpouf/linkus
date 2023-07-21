import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/utilities/my_navigation_bar.dart';
import 'package:linkus/view/auth/login_view.dart';
import 'package:linkus/view/auth/register_view.dart';
import 'package:linkus/view/auth/verify_email_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // tests for registering
  group('register view test', () {
    testWidgets('Weak password dialogue appears', (tester) async {
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
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byKey(const Key('weak_password')), findsOneWidget);
    });

    testWidgets('Email already in use dialogue appears', (tester) async {
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
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byKey(const Key('email_used')), findsOneWidget);
    });

    testWidgets('Invalid email dialogue appears', (tester) async {
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
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byKey(const Key('invalid_email')), findsOneWidget);
    });

    // must remove test email from firebase to test this
    testWidgets('Registering navigates to verify email view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            verifyEmailRoute: (context) => const VerifyEmailView(),
          },
          home: const RegisterView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password');

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(VerifyEmailView), findsOneWidget);
    });
  });

  // tests for logging in
  group('login view test', () {
    testWidgets('User not found dialogue appears', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'nouser@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password');

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byKey(const Key('user_not_found')), findsOneWidget);
    });

    testWidgets('Incorrect password dialogue appears', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'linkusrandc@gmail.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password');

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byKey(const Key('incorrect_password')), findsOneWidget);
    });

    testWidgets('Logging in navigates to profile view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            profileRoute: (context) => const MyNavigationBar(index: 2,),
          },
          home: const LoginView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'linkusrandc@gmail.com');
      await tester.enterText(find.byKey(const Key('password_field')), '123456');

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(MyNavigationBar), findsOneWidget);
    });
  });
}
