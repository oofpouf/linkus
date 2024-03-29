import 'package:flutter/material.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/services/auth/auth_exceptions.dart';
import 'package:linkus/services/profile/firebase_profile_service.dart';
import '../../services/auth/auth_service.dart';
import '../../utilities/error_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Streambuilder to see if user is new

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Link icon
            Image.asset(
              'lib/icons/link.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10),

            // Login title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromARGB(255, 68, 23, 13),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Email textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 233, 221),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    key: const Key('email_field'),
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: const Color.fromARGB(255, 68, 23, 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Password textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 233, 221),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    key: const Key('password_field'),
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: const Color.fromARGB(255, 68, 23, 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GestureDetector(
                onTap: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService.firebase().logIn(
                      email: email,
                      password: password,
                    );
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified ?? false) {
                      FirebaseProfileService profiles =
                          FirebaseProfileService();
                      bool profileExists =
                          await profiles.profileExists(email: user!.email);
                      if (profileExists) {
                        // check if user exists
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            profileRoute, (route) => false);
                      } else {
                        await profiles.createNewProfile(email: user.email);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            editProfileRoute, (route) => false);
                      }
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute, (route) => false);
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(
                        context, 'User not found', 'user_not_found');
                  } on WrongPasswordAuthException {
                    await showErrorDialog(
                        context, 'Incorrect password', 'incorrect_password');
                  } on GenericAuthException {
                    await showErrorDialog(
                        context, 'Authentication error', 'auth_error');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 23, 13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      key: const Key('login_button'),
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 241, 233, 221),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Transition to RegisterView
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 241, 233, 221),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  },
                  child: Text(
                    'Register now!',
                    style: GoogleFonts.comfortaa(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 68, 23, 13),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
