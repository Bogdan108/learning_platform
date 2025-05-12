import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';

class StudentRootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StudentRootScreen({
    required this.navigationShell,
    super.key,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final profileBloc = DependenciesScope.of(context).profileBloc;

    return BlocBuilder<ProfileBloc, ProfileBlocState>(
      bloc: profileBloc,
      builder: (context, state) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.done_outline_sharp),
                label: 'Задания',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
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
      },
    );
  }
}
