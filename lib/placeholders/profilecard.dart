import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 580,
      width: 340,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                profile.imageAsset,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 100,
              width: 340,
              decoration: ShapeDecoration(
                color: const Color.fromARGB(255, 241, 233, 221),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profile.name,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 68, 23, 13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "year ${profile.year}",
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      profile.distance,
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (profile.isLiked) // Display match indicator
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors
                              .green, // Choose the desired match indicator color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Matched',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
