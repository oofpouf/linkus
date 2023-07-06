import 'package:flutter/material.dart';

class MatchHistoryView extends StatefulWidget {
  const MatchHistoryView({super.key});

  @override
  State<MatchHistoryView> createState() => _MatchHistoryViewState();
}

class _MatchHistoryViewState extends State<MatchHistoryView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffAA8E63),
      body: Center(
        child: Text("Match History Page"),
      ),
    );
  }
}
