import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/widget/custom_error_widget.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_event.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profileBloc = DependenciesScope.of(context).profileBloc;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BlocBuilder<ProfileBloc, ProfileBlocState>(
          bloc: profileBloc,
          builder: (context, state) => switch (state) {
            Loading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            Idle(profileInfo: final info) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${info.fullName.secondName} ${info.fullName.firstName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    info.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    info.role.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () => context.goNamed(
                      info.role == UserRole.student
                          ? 'edit'
                          : info.role == UserRole.admin
                              ? 'adminEdit'
                              : 'teacherEdit',
                      extra: state.profileInfo,
                    ),
                    child: const Text(
                      'Редактировать данные',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      DependenciesScope.of(context).authBloc.add(
                            const AuthBlocEvent.signOut(),
                          );
                    },
                    child: const Text(
                      'Выйти из системы',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            Error(error: final message, event: final event) => Center(
                child: CustomErrorWidget(
                  errorMessage: message,
                  onRetry: event != null ? () => profileBloc.add(event) : null,
                ),
              ),
          },
        ),
      ),
    );
  }
}
