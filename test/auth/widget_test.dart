import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkus/view/auth/register_view.dart';

void main() {
  testWidgets('Weak password dialogue appears', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegisterView(),
      ),
    );

    await tester.enterText(
        find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'p');

    await tester.tap(find.byKey(const Key('register_button')));
    await tester.pump();

    expect(find.byKey(const Key('weak_password')), findsOneWidget);
    expect(find.text('Weak password'), findsOneWidget);
  });
}
