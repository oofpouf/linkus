import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';
import 'package:linkus/services/profile/profile_ui_functions.dart';

import '../../services/auth/auth_service.dart';
import '../../utilities/show_error_dialogue.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // current user
  final currentUser = AuthService.firebase().currentUser;

  @override
  Widget build(BuildContext context) {
    ProfileUIFunctions userProf = ProfileUIFunctions();
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      appBar: AppBar(
        backgroundColor: const Color(0xffAA8E63),
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 68, 23, 13),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Color.fromARGB(255, 68, 23, 13),
              size: 30,
            ),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile picture
                      userProf.generatePfp(userData['profile pic']),
                      const SizedBox(height: 20),

                      // User name
                      userProf.generateName(userData['name']),

                      // Tele handle
                      userProf.generateTeleHandle(userData['tele handle']),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),

                      // Year of study
                      userProf.generateTitle('Year of Study'),
                      const SizedBox(height: 2),

                      // YOS description
                      userProf.generateBodyText(userData['year']),
                      const SizedBox(height: 25),

                      // Degree
                      userProf.generateTitle('Degree'),
                      const SizedBox(height: 2),

                      // Degree description
                      userProf.generateBodyText(userData['degree']),
                      const SizedBox(height: 25),

                      // Courses
                      userProf.generateTitle('Courses'),
                      const SizedBox(height: 2),

                      // Courses description
                      userProf.generateBodyText(userData['course 1'] +
                          ', ' +
                          userData['course 2'] +
                          ', ' +
                          userData['course 3']),
                      const SizedBox(height: 25),

                      // Hobbies
                      userProf.generateTitle('Hobbies'),
                      const SizedBox(height: 2),

                      // Hobbies description
                      userProf.generateBodyText(userData['hobby 1'] +
                          ', ' +
                          userData['hobby 2'] +
                          ', ' +
                          userData['hobby 3']),
                      const SizedBox(height: 40),

                      // Edit profile button
                      SizedBox(
                        width: 220,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pushNamed(editProfileRoute);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 68, 23, 13),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Edit Profile",
                            style: GoogleFonts.comfortaa(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 241, 233, 221),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              showErrorDialog(this.context, 'Error${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 241, 233, 221),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Color.fromARGB(255, 63, 50, 30),
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Color.fromARGB(255, 63, 50, 30),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 63, 50, 30),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Color.fromARGB(255, 63, 50, 30),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
