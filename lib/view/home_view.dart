import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';
import '../services/auth/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffAA8E63),
      appBar: AppBar(
        backgroundColor: const Color(0xffAA8E63),
        title: const Text(
          'Main Page',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Color.fromARGB(255, 63, 50, 30)),
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome! Work in progress :)",
          style: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 241, 233, 221),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
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
