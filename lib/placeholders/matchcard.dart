import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchCard extends StatelessWidget {
  final String email;
  final VoidCallback onMatchRemoved;


   const MatchCard({
    Key? key,
    required this.email,
    required this.onMatchRemoved,
  }) : super(key: key);

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
                Expanded(child:
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
                      'Tele ID: @$telegramId',
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        )
                      )
                    ),
                  ],
                ),
                ),
                IconButton(
                  onPressed: () => _removeMatch(context),
                  icon: Icon(Icons.clear),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeMatch(BuildContext context) async {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserEmail) // The current user's document
          .update({
        'matches': FieldValue.arrayRemove([email]),
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(email) // The current user's document
          .update({
        'likes': FieldValue.arrayRemove([currentUserEmail]),
      });

      onMatchRemoved(); // Notify MatchHistoryView about the match removal

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Match removed successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing match')),
      );
    }
  }
}
