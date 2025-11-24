import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  final StatefulNavigationShell shell;
  const LayoutScaffold({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: shell,
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.only(top: 8),
        child: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.black,
          onTap: (value) {
            shell.goBranch(value);
          },
          currentIndex: shell.currentIndex,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.grey,
              icon: Icon(Icons.chat_rounded),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}
