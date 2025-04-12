import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/admin/widget/pages/admin_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/email_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/login_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/register_page.dart';
import 'package:learning_platform/src/feature/courses/model/course_model.dart';
import 'package:learning_platform/src/feature/courses/widget/course_page.dart';
import 'package:learning_platform/src/feature/courses/widget/courses_page.dart';
import 'package:learning_platform/src/feature/profile/widget/profile_page.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/admin',
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
        path: '/admin',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AdminHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
      ),
      GoRoute(
        path: '/courses',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const CoursesPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
        routes: [
          GoRoute(
            path: '/details',
            builder: (context, state) {
              final course = state.extra! as Course;
              return CourseDetailPage(course: course);
            },
          )
        ],
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: _defaultFadeTransitionDuration,
          reverseTransitionDuration: _defaultFadeTransitionDuration,
        ),
      ),
    ],
  );
}
