import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/email_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/login_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/register_page.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RegisterPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
        routes: [
          GoRoute(
            path: 'validate_code',
            builder: (context, state) {
              // Передаём данные из extra
              final data = state.extra as Map<String, String>;
              return EmailPage(
                firstName: data['firstName']!,
                lastName: data['lastName']!,
                email: data['email']!,
                password: data['password']!,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
      ),
    ],
  );
}

// Простейшая заглушка для главного экрана
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: const Center(child: Text('Welcome Home!')),
      );
}
