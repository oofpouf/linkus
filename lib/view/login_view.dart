import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkus/constants/routes.dart';
import '../utilities/show_error_dialogue.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Login title
              const SizedBox(height: 25),
              const Text(
                'Login',
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
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final user = FirebaseAuth.instance.currentUser;
                          if (user?.emailVerified ?? false) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                mainRoute, (route) => false);
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute,
                              (route) => false,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            await showErrorDialog(
                              context,
                              'User not found',
                            );
                          } else if (e.code == 'wrong-password') {
                            await showErrorDialog(
                              context,
                              'Incorrect password',
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
                        'Login',
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

              // Transition to RegisterView
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member? ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 241, 233, 221),
                        fontWeight: FontWeight.bold,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute, (route) => false);
                    },
                    child: const Text(
                      'Register now!',
                      style: TextStyle(
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

// To display error message to user
