import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkus/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Verify title
              const SizedBox(height: 25),
              const Text(
                'Verify your email',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Color.fromARGB(255, 63, 50, 30)),
              ),
              const SizedBox(height: 30),

              // Email verification sent text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "We've sent you an email verification. Please open it to verify your account.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 241, 233, 221),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),

              // Resend verification text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Haven't received a verification email? Click the button below",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 241, 233, 221),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),

              // Resend verification button
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
                        final user = FirebaseAuth.instance.currentUser;
                        await user?.sendEmailVerification();
                      },
                      child: const Text(
                        'Resend email verification',
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
                  const Text("Or return to",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 241, 233, 221),
                        fontWeight: FontWeight.bold,
                      )),

                  // Return to register button
                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      ' register page',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 63, 50, 30),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
              // Return to register text
            ],
          ),
        ),
      ),
    );
  }
}
