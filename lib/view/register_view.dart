import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/utilities/show_error_dialogue.dart';

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
              // Register title
              const SizedBox(height: 25),
              const Text(
                'Register',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Color.fromARGB(255, 63, 50, 30)),
              ),
              const SizedBox(height: 30),

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
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 63, 50, 30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          Navigator.of(context).pushNamed(
                              verifyEmailRoute); // push named so that entire route is not replaced (can go back to register route from verify email route)
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            await showErrorDialog(
                              context,
                              'Weak password',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            await showErrorDialog(
                              context,
                              'Email is already in use',
                            );
                          } else if (e.code == 'invalid-email') {
                            await showErrorDialog(
                              context,
                              'Invalid email address',
                            );
                          } else {
                            await showErrorDialog(
                              context,
                              'Error: ${e.code}',
                            );
                          }
                        } catch (e) {
                          await showErrorDialog(
                            context,
                            e.toString(),
                          );
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Color.fromARGB(255, 241, 233, 221),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
                  const Text('Already a member? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 241, 233, 221),
                        fontWeight: FontWeight.bold,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    },
                    child: const Text(
                      'Login now!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 63, 50, 30),
                        fontWeight: FontWeight.bold,
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
