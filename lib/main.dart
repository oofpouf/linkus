import 'package:flutter/material.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/services/auth/auth_service.dart';
import 'package:linkus/view/edit_profile_view.dart';
import 'package:linkus/view/login_view.dart';
import 'package:linkus/view/home_view.dart';
import 'package:linkus/view/profile_view.dart';
import 'package:linkus/view/register_view.dart';
import 'package:linkus/view/verify_email_view.dart'; // so that you can call devtools.log instead of just log

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 50, 30),
        ),
        useMaterial3: true,
      ),
      home: const Transitions(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const HomeView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        profileRoute: (context) => const ProfileView(),
        editProfileRoute: (context) => const EditProfileView(),
      },
    ),
  );
}

class Transitions extends StatelessWidget {
  const Transitions({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const ProfileView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
