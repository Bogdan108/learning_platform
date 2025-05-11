import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/root_screen/admin_root_screen.dart';
import 'package:learning_platform/src/core/root_screen/user_root_screen.dart';
import 'package:learning_platform/src/feature/admin/widget/pages/courses_manage_page.dart';
import 'package:learning_platform/src/feature/admin/widget/pages/users_manage_page.dart';
import 'package:learning_platform/src/feature/assignment/widget/assignment_page.dart';
import 'package:learning_platform/src/feature/assignment/widget/student_assignments_page.dart';
import 'package:learning_platform/src/feature/assignment/widget/teacher_assignment_answers_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/email_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/login_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/register_page.dart';
import 'package:learning_platform/src/feature/course/widget/course_detail_page.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/widget/courses_page.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/widget/edit_profile_page.dart';
import 'package:learning_platform/src/feature/profile/widget/profile_page.dart';
import 'package:learning_platform/src/feature/task/widget/answer_tasks_page.dart';
import 'package:learning_platform/src/feature/task/widget/evaluate_tasks_page.dart';
import 'package:learning_platform/src/feature/task/widget/task_page.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'login',
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
        name: 'register',
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
            name: 'validateCode',
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
                name: 'studentAssignments',
                path: '/student_assignments',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const StudentAssignmentsPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
                  transitionDuration: _defaultFadeTransitionDuration,
                  reverseTransitionDuration: _defaultFadeTransitionDuration,
                ),
                routes: [
                  GoRoute(
                    name: 'studentEvaluateAnswers',
                    path: 'student_evaluate_answers/:answerId',
                    builder: (ctx, state) {
                      final answerId = state.pathParameters['answerId']!;
                      final title = state.extra! as String;

                      // TODO(b.luckyanchuk): Implement assignmentId after backend will be ready
                      return EvaluateTasksPage(
                        answerId: answerId,
                        assignmentId: '1',
                        title: title,
                      );
                    },
                  ),
                  GoRoute(
                    name: 'answerAssignment',
                    path: 'answer_assignment/:assignmentId',
                    builder: (ctx, state) {
                      final assignmentId = state.pathParameters['assignmentId']!;
                      final title = state.extra! as String;

                      // TODO(b.luckyanchuk): Implement assignmentId after backend will be ready
                      return AnswerTasksPage(
                        assignmentId: assignmentId,
                        title: title,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'courses',
                path: '/',
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
                    name: 'courseDetails',
                    path: 'course_details',
                    builder: (context, state) {
                      final course = state.extra! as Course;

                      return CourseDetailPage(courseDetails: course);
                    },
                    routes: [
                      GoRoute(
                        name: 'assignments',
                        path: 'assignments/:courseId',
                        builder: (ctx, state) {
                          final courseId = state.pathParameters['courseId']!;

                          return AssignmentsPage(courseId: courseId);
                        },
                        routes: [
                          GoRoute(
                            name: 'tasks',
                            path: 'tasks/:assignmentId',
                            builder: (ctx, state) {
                              final assignmentId = state.pathParameters['assignmentId']!;

                              return TasksPage(
                                assignmentId: assignmentId,
                              );
                            },
                          ),
                          GoRoute(
                            name: 'courseStudentEvaluateAnswers',
                            path: 'course_student_evaluate_answers/:answerId',
                            builder: (ctx, state) {
                              final answerId = state.pathParameters['answerId']!;
                              final title = state.extra! as String;

                              // TODO(b.luckyanchuk): Implement assignmentId after backend will be ready
                              return EvaluateTasksPage(
                                answerId: answerId,
                                assignmentId: '1',
                                title: title,
                              );
                            },
                          ),
                          GoRoute(
                            name: 'courseAnswerAssignment',
                            path: 'course_answer_assignment/:assignmentId',
                            builder: (ctx, state) {
                              final assignmentId = state.pathParameters['assignmentId']!;
                              final title = state.extra! as String;

                              // TODO(b.luckyanchuk): Implement assignmentId after backend will be ready
                              return AnswerTasksPage(
                                assignmentId: assignmentId,
                                title: title,
                              );
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        name: 'answers',
                        path: 'answers/:courseId',
                        builder: (ctx, state) {
                          final courseId = state.pathParameters['courseId']!;

                          return AssignmentAnswersPage(courseId: courseId);
                        },
                        routes: [
                          GoRoute(
                            name: 'evaluateAnswers',
                            path: 'evaluate_answers/:answerId',
                            builder: (ctx, state) {
                              final answerId = state.pathParameters['answerId']!;
                              final title = state.extra! as String;

                              // TODO(b.luckyanchuk): Implement assignmentId after backend will be ready
                              return EvaluateTasksPage(
                                answerId: answerId,
                                assignmentId: '1',
                                title: title,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'profile',
                path: '/profile',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProfilePage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
                  transitionDuration: _defaultFadeTransitionDuration,
                  reverseTransitionDuration: _defaultFadeTransitionDuration,
                ),
                routes: [
                  GoRoute(
                    name: 'edit',
                    path: 'edit',
                    builder: (context, state) {
                      final user = state.extra! as User;
                      return EditProfilePage(user: user);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) =>
            UserRootScreen(navigationShell: navigationShell),
      ),
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'adminCourses',
                path: '/admin_courses',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CoursesManagePage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
                  transitionDuration: _defaultFadeTransitionDuration,
                  reverseTransitionDuration: _defaultFadeTransitionDuration,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'adminUsers',
                path: '/admin_users',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const UsersManagePage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
                  transitionDuration: _defaultFadeTransitionDuration,
                  reverseTransitionDuration: _defaultFadeTransitionDuration,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'adminProfile',
                path: '/admin_profile',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProfilePage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
                  transitionDuration: _defaultFadeTransitionDuration,
                  reverseTransitionDuration: _defaultFadeTransitionDuration,
                ),
                routes: [
                  GoRoute(
                    name: 'editAdmin',
                    path: 'edit',
                    builder: (context, state) {
                      final user = state.extra! as User;
                      return EditProfilePage(user: user);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) =>
            AdminRootScreen(navigationShell: navigationShell),
      ),
    ],
  );
}
