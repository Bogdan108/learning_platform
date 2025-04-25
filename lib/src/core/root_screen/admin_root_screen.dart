import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminRootScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AdminRootScreen({
    required this.navigationShell,
    super.key,
  });

  @override
  State<AdminRootScreen> createState() => _AdminRootScreenState();
}

class _AdminRootScreenState extends State<AdminRootScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Курсы',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Пользователи',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
          currentIndex: widget.navigationShell.currentIndex,
          onTap: widget.navigationShell.goBranch,
        ),
      );
}
