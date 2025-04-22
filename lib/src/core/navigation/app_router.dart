import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/root_screen/user_root_screen.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/email_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/login_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/register_page.dart';
import 'package:learning_platform/src/feature/course/widget/course_detail_page.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/widget/courses_page.dart';
import 'package:learning_platform/src/feature/profile/widget/profile_page.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
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
              final data = state.extra! as Map<String, String>;
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
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CoursesPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                  transitionDuration: _defaultFadeTransitionDuration,
                  reverseTransitionDuration: _defaultFadeTransitionDuration,
                ),
                routes: [
                  GoRoute(
                    path: '/course_details',
                    builder: (context, state) {
                      final course = state.extra! as Course;
                      return CourseDetailPage(courseDetails: course);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProfilePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                  transitionDuration: _defaultFadeTransitionDuration,
                  reverseTransitionDuration: _defaultFadeTransitionDuration,
                ),
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) =>
            UserRootScreen(navigationShell: navigationShell),
      ),
    ],
  );
}
