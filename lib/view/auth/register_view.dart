import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/services/auth/auth_exceptions.dart';
import 'package:linkus/services/auth/auth_user.dart';
import 'package:linkus/utilities/show_error_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      body: SafeArea(
        child: Center(
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

              // Register title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Register',
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
                          hintText: 'Enter your email here'),
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
                          hintText: 'Enter your password here'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Register button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                  onTap: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      AuthUser userCredential =
                          await AuthService.firebase().createUser(
                        email: email,
                        password: password,
                      );
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(userCredential.email)
                          .set({
                        'profile pic': "",
                        'name': "",
                        'tele handle': "",
                        'year': "",
                        'degree': "",
                        'course 1': "",
                        'course 2': "",
                        'course 3': "",
                        'hobby 1': "",
                        'hobby 2': "",
                        'hobby 3': "",
                      });
                      AuthService.firebase().sendEmailVerification();
                      Navigator.of(context).pushNamed(
                          verifyEmailRoute); // push named so that entire route is not replaced
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'Weak password',
                      );
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(
                        context,
                        'Email is already in use',
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        'Invalid email address',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Failed to register',
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
                        'Register',
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member? ',
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
                          loginRoute, (route) => false);
                    },
                    child: Text(
                      'Login now!',
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
      ),
    );
  }
}
