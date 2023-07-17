import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../placeholders/matchcard.dart';

class MatchHistoryView extends StatefulWidget {
  const MatchHistoryView({Key? key}) : super(key: key);

  @override
  State<MatchHistoryView> createState() => _MatchHistoryViewState();
}

class _MatchHistoryViewState extends State<MatchHistoryView> {
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  List<String> matchEmails = [];

  @override
  void initState() {
    super.initState();
    processMatches();
  }

  Future<List<dynamic>> getMatches() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = usersCollection.doc(currentUserEmail);

    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        final matches = snapshot.data()?['matches'];
        return matches != null ? List<dynamic>.from(matches) : [];
      }
    } catch (error) {
      debugPrint('Error retrieving matches: $error');
    }

    return [];
  }

  Future<void> processMatches() async {
    List<dynamic> matches = await getMatches();
    setState(() {
      matchEmails = List<String>.from(matches);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Match History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: matchEmails.length,
                itemBuilder: (context, index) {
                  return MatchCard(email: matchEmails[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
