import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../utilities/show_error_dialogue.dart';
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
                      // query for user data
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(user?.email)
                          .get()
                          .then((DocumentSnapshot<Map<String, dynamic>>
                              snapshot) {
                        if (snapshot.exists) {
                          final userData = snapshot.data()!;
                          for (String fieldName in userData.keys) {
                            if (userData[fieldName] == "") {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  editProfileRoute, (route) => false);
                              return; // Exit the function after navigating
                            }
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              myNavigationBarRoute, (route) => false);
                        }
                      });
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute, (route) => false);
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } on WrongPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Incorrect password',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Authentication error',
                    );
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

// To display error message to user
