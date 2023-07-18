import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchCard extends StatelessWidget {
  final String email;

  const MatchCard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('Users').doc(email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: Text('Error retrieving match data'),
            ),
          );
        }
        final matchData = snapshot.data!.data()!;
        final profilePic = matchData['profile pic'];
        final name = matchData['name'];
        final telegramId = matchData['tele handle'];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(profilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 68, 23, 13),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Tele ID: $telegramId',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
