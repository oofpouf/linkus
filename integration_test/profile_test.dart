import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/services/auth/auth_service.dart';
import 'package:linkus/services/profile/firebase_profile_service.dart';
import 'package:linkus/utilities/my_navigation_bar.dart';
import 'package:linkus/view/auth/login_view.dart';
import 'package:linkus/view/profile/edit_profile_view.dart';
import 'package:linkus/view/profile/profile_view.dart';

// mock image picker

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();

    // log into existing account
    await AuthService.firebase().logIn(
      email: 'linkusrandc@gmail.com',
      password: '123456',
    );

    // preset fields in profile page
    final profiles = FirebaseProfileService();
    await profiles.updateProfile(
        profilePic:
            'https://firebasestorage.googleapis.com/v0/b/linkus-randc.appspot.com/o/Images%2Flinkusrandc%40gmail.com%2F1689729672326?alt=media&token=d989a64f-9141-4de5-8906-7949ab9bf6fd',
        email: 'linkusrandc@gmail.com',
        name: 'default_name',
        teleHandle: 'default_telehandle',
        year: '1',
        degree: 'default_degree',
        hobby1: 'default_hobby1',
        hobby2: 'default_hobby2',
        hobby3: 'default_hobby3');
  });

  group('Profile view test before edits', () {
    testWidgets('Profile view displays default setup', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_pic')), findsOneWidget);
      expect(find.text('default_name'), findsOneWidget);
      expect(find.text('default_telehandle'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('default_degree'), findsOneWidget);
      expect(find.text('default_hobby1, default_hobby2, default_hobby3'),
          findsOneWidget);
    });

    testWidgets('Edit profile navigates to edit profile view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            editProfileRoute: (context) => const EditProfileView(),
          },
          home: const ProfileView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('edit_profile_button')));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(EditProfileView), findsOneWidget);
    });
  });

  group('Edit profile view tests', () {
    testWidgets('Return to profile page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const EditProfileView(),
          routes: {
            myNavigationBarRoute: (context) => const MyNavigationBar(),
          },
        ),
      );
      await tester.pumpAndSettle();

      final leadingIcon = find.byIcon(Icons.arrow_back_ios_new_rounded);
      await tester.tap(leadingIcon);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.byKey(const Key('return_text')));
      await tester.pumpAndSettle(const Duration(seconds: 10));
      expect(find.byType(MyNavigationBar), findsOneWidget);
    });

    testWidgets('Empty field dialog appears', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditProfileView(),
        ),
      );
      await tester.pumpAndSettle();

      final updateChangesButton = find.byKey(const Key('update_changes'));
      await tester.ensureVisible(updateChangesButton);
      await tester.tap(updateChangesButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byKey(const Key('empty_field')), findsOneWidget);
    });

    testWidgets('Invalid year dialog appears', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditProfileView(),
        ),
      );
      await tester.pumpAndSettle();

      // fill in text fields
      await tester.enterText(find.byKey(const Key('name_field')), 'r&c');
      await tester.enterText(
          find.byKey(const Key('tele_handle_field')), '@linkusrandc');
      await tester.enterText(find.byKey(const Key('year_field')), '0');
      await tester.enterText(
          find.byKey(const Key('degree_field')), 'business analytics');

      // select 1st dropdown button
      final finder1 = find.byKey(const Key('hobby1_field'));
      await tester.tap(finder1);
      await tester.pumpAndSettle();
      final itemFinder1 = find.text("arts and crafts");
      await tester.tap(itemFinder1);
      await tester.pumpAndSettle();

      // select 2nd dropdown button
      final finder2 = find.byKey(const Key('hobby2_field'));
      await tester.tap(finder2);
      await tester.pumpAndSettle();
      final itemFinder2 = find.text("board/card games");
      await tester.tap(itemFinder2);
      await tester.pumpAndSettle();

      // select 3rd dropdown button
      final finder3 = find.byKey(const Key('hobby3_field'));
      await tester.ensureVisible(finder3);
      await tester.tap(finder3);
      await tester.pumpAndSettle();
      final itemFinder3 = find.text("cooking/baking");
      await tester.tap(itemFinder3);
      await tester.pumpAndSettle();

      final updateChangesButton = find.byKey(const Key('update_changes'));
      await tester.ensureVisible(updateChangesButton);
      await tester.tap(updateChangesButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byKey(const Key('invalid_year')), findsOneWidget);
    });

    testWidgets('Update changes navigates to profile view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            myNavigationBarRoute: (context) => const MyNavigationBar(),
          },
          home: const EditProfileView(),
        ),
      );
      await tester.pumpAndSettle();

      // fill in text fields
      await tester.enterText(find.byKey(const Key('name_field')), 'r&c');
      await tester.enterText(
          find.byKey(const Key('tele_handle_field')), '@linkusrandc');
      await tester.enterText(find.byKey(const Key('year_field')), '2');
      await tester.enterText(
          find.byKey(const Key('degree_field')), 'business analytics');

      // select 1st dropdown button
      final finder1 = find.byKey(const Key('hobby1_field'));
      await tester.tap(finder1);
      await tester.pumpAndSettle();
      final itemFinder1 = find.text("arts and crafts");
      await tester.tap(itemFinder1);
      await tester.pumpAndSettle();

      // select 2nd dropdown button
      final finder2 = find.byKey(const Key('hobby2_field'));
      await tester.tap(finder2);
      await tester.pumpAndSettle();
      final itemFinder2 = find.text("board/card games");
      await tester.tap(itemFinder2);
      await tester.pumpAndSettle();

      // select 2nd dropdown button
      final finder3 = find.byKey(const Key('hobby3_field'));
      await tester.ensureVisible(finder3);
      await tester.tap(finder3);
      await tester.pumpAndSettle();
      final itemFinder3 = find.text("cooking/baking");
      await tester.tap(itemFinder3);
      await tester.pumpAndSettle();

      final updateChangesButton = find.byKey(const Key('update_changes'));
      await tester.ensureVisible(updateChangesButton);
      await tester.tap(updateChangesButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(MyNavigationBar), findsOneWidget);
    });
  });

  group('Profile view test after edits', () {
    testWidgets('Profile view displays edited profile', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_pic')), findsOneWidget);
      expect(find.text('r&c'), findsOneWidget);
      expect(find.text('@linkusrandc'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('business analytics'), findsOneWidget);
      expect(find.text('arts and crafts, board/card games, cooking/baking'),
          findsOneWidget);
    });
  });

  group('Logout test', () {
    testWidgets('Logs out of application successfuly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfileView(),
          routes: {
            loginRoute: (context) => const LoginView(),
          },
        ),
      );
      await tester.pumpAndSettle();

      final menuButton = find.byIcon(Icons.logout_rounded);
      await tester.tap(menuButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.byKey(const Key('logout_text')));
      await tester.pumpAndSettle(const Duration(seconds: 10));
      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
