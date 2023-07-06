import 'package:flutter/material.dart';
import 'package:linkus/placeholders/cardstackwidget.dart';
import 'package:linkus/view/match_history_view.dart';
import 'package:linkus/view/profile/profile_view.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    MatchHistoryView(),
    CardsStackWidget(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CardsStackWidget()));
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people_alt_rounded,
              ),
              label: 'Link Up',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: const Color(0xffAA8E63),
          selectedItemColor: const Color.fromARGB(255, 241, 233, 221),
          backgroundColor: const Color.fromARGB(255, 68, 23, 13),
          onTap: _onItemTapped),
    );
  }
}
