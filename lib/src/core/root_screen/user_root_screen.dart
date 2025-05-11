import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserRootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const UserRootScreen({
    required this.navigationShell,
    super.key,
  });

  @override
  @override
  Widget build(BuildContext context) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.done_outline_sharp),
              label: 'Задания',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Курсы',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
          currentIndex: navigationShell.currentIndex,
          onTap: navigationShell.goBranch,
        ),
      );
}
