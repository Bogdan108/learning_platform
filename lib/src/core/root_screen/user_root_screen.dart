import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class UserRootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const UserRootScreen({
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
        final userRole = state.profileInfo.role;
        final isStudent = userRole == UserRole.student;

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              if (isStudent)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline_sharp),
                  label: 'Задания',
                ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Курсы',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Профиль',
              ),
            ],
            currentIndex:
                isStudent ? navigationShell.currentIndex : navigationShell.currentIndex - 1,
            onTap: navigationShell.goBranch,
          ),
        );
      },
    );
  }
}
