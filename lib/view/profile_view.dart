import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkus/constants/routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile picture
              SizedBox(
                width: 170,
                height: 170,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Image(image: AssetImage('lib/icons/ai.jpg'))),
              ),
              const SizedBox(height: 15),

              // User name
              Text(
                "Ai Hoshino",
                style: GoogleFonts.comfortaa(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 68, 23, 13),
                  ),
                ),
              ),

              // Tele handle
              Text(
                "tele handle: @ai_hoshino",
                style: GoogleFonts.comfortaa(
                  textStyle: const TextStyle(fontSize: 16),
                  color: const Color.fromARGB(255, 241, 233, 221),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Year of study
              Align(
                alignment: Alignment.centerLeft,
                child:
                    // Year of study
                    Text(
                  "Year of Study",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 68, 23, 13),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // Year of study description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Year 1",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 241, 233, 221),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Degree
              Align(
                alignment: Alignment.centerLeft,
                child:
                    // Year of study
                    Text(
                  "Degree",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 68, 23, 13),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // Degree description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Idol",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 241, 233, 221),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Courses
              Align(
                alignment: Alignment.centerLeft,
                child:
                    // Year of study
                    Text(
                  "Courses",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 68, 23, 13),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // Courses description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ONK45510, RH158, AH172",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 241, 233, 221),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Hobbies
              Align(
                alignment: Alignment.centerLeft,
                child:
                    // Year of study
                    Text(
                  "Hobbies",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 68, 23, 13),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // Hobbies description
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Singing, dancing, babysitting",
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 241, 233, 221),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 45),

              // Edit profile button
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamed(editProfileRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 68, 23, 13),
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
            ],
          ),
        ),
      ),
    );
  }
}
