import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';

import '../../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  // To return to login page once email has been verified
  bool isVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await AuthService.firebase().currentUser?.reload();

    setState(() {
      isVerified = AuthService.firebase().currentUser!.isEmailVerified;
    });
    if (isVerified) {
      timer?.cancel();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(loginRoute, (route) => false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
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
              const Icon(
                Icons.email_rounded,
                size: 120,
                color: Color.fromARGB(255, 68, 23, 13),
              ),

              // Verify title
              Text(
                'Verify your email',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color.fromARGB(255, 68, 23, 13),
                  ),
                ),
              ),
              const SizedBox(height: 38),

              // Email verification sent text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "We've sent you an email verification. Please open it to verify your account.",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 241, 233, 221),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),

              // Resend verification text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Haven't received a verification email? Click the button below",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 241, 233, 221),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),

              // Resend verification button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                  onTap: () async {
                    await AuthService.firebase().sendEmailVerification();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 68, 23, 13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Resend email verification',
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
                    "Or return to",
                    style: GoogleFonts.comfortaa(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 241, 233, 221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Return to register button
                  GestureDetector(
                    onTap: () async {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                        (route) => false,
                      );
                    },
                    child: Text(
                      ' register page',
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 68, 23, 13),
                          fontWeight: FontWeight.bold,
                        ),
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
