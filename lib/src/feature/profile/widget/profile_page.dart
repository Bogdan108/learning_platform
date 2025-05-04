import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: BlocBuilder<ProfileBloc, ProfileBlocState>(
            bloc: DependenciesScope.of(context).profileBloc,
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
                        'edit',
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
                        //context.read<AuthBloc>().add(const SignOutEvent());
                        context.goNamed('login');
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
              Error(error: final message) => Center(
                  child: Text(
                    'Ошибка: $message',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            },
          ),
        ),
      );
}
