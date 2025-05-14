import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/root_screen/admin_root_screen.dart';
import 'package:learning_platform/src/core/root_screen/student_root_screen.dart';
import 'package:learning_platform/src/core/root_screen/teacher_root_screen.dart';
import 'package:learning_platform/src/feature/admin/widget/pages/courses_manage_page.dart';
import 'package:learning_platform/src/feature/admin/widget/pages/users_manage_page.dart';
import 'package:learning_platform/src/feature/assignment/model/student_answer.dart';
import 'package:learning_platform/src/feature/assignment/widget/assignment_page.dart';
import 'package:learning_platform/src/feature/assignment/widget/student_assignments_page.dart';
import 'package:learning_platform/src/feature/assignment/widget/teacher_assignment_answers_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/email_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/login_page.dart';
import 'package:learning_platform/src/feature/authorization/widget/pages/register_page.dart';
import 'package:learning_platform/src/feature/course/course_details/widget/course_detail_page.dart';
import 'package:learning_platform/src/feature/course/model/course.dart';
import 'package:learning_platform/src/feature/course/widget/courses_page.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/widget/edit_profile_page.dart';
import 'package:learning_platform/src/feature/profile/widget/profile_page.dart';
import 'package:learning_platform/src/feature/task/widget/answer_tasks_page.dart';
import 'package:learning_platform/src/feature/task/widget/evaluate_tasks_page.dart';
import 'package:learning_platform/src/feature/task/widget/task_page.dart';

const _defaultFadeTransitionDuration = Duration(milliseconds: 200);

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter initRouter(String initialLocation) => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: initialLocation,
        routes: [
          GoRoute(
            name: 'login',
            path: '/login',
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
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
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
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

          /// Student navigation
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
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                      transitionDuration: _defaultFadeTransitionDuration,
                      reverseTransitionDuration: _defaultFadeTransitionDuration,
                    ),
                    routes: [
                      GoRoute(
                        name: 'studentEvaluateAnswers',
                        path: 'student_evaluate_answers/:assignmentId',
                        builder: (ctx, state) {
                          final assignmentId =
                              state.pathParameters['assignmentId']!;
                          final title = state.extra! as String;

                          return EvaluateTasksPage(
                            assignmentId: assignmentId,
                            title: title,
                          );
                        },
                      ),
                      GoRoute(
                        name: 'answerAssignment',
                        path: 'answer_assignment/:assignmentId',
                        builder: (ctx, state) {
                          final assignmentId =
                              state.pathParameters['assignmentId']!;
                          final title = state.extra! as String;

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
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
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
                              final courseId =
                                  state.pathParameters['courseId']!;

                              return AssignmentsPage(courseId: courseId);
                            },
                            routes: [
                              GoRoute(
                                name: 'tasks',
                                path: 'tasks/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;

                                  return TasksPage(
                                    assignmentId: assignmentId,
                                  );
                                },
                              ),
                              GoRoute(
                                name: 'courseStudentEvaluateAnswers',
                                path:
                                    'course_student_evaluate_answers/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;
                                  final title = state.extra! as String;

                                  return EvaluateTasksPage(
                                    assignmentId: assignmentId,
                                    title: title,
                                  );
                                },
                              ),
                              GoRoute(
                                name: 'courseAnswerAssignment',
                                path: 'course_answer_assignment/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;
                                  final title = state.extra! as String;

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
                              final courseId =
                                  state.pathParameters['courseId']!;

                              return TeacherAssignmentAnswersPage(
                                  courseId: courseId);
                            },
                            routes: [
                              GoRoute(
                                name: 'evaluateAnswers',
                                path: 'evaluate_answers/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;
                                  final title = state.extra! as String;

                                  return EvaluateTasksPage(
                                    assignmentId: assignmentId,
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
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
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
                StudentRootScreen(navigationShell: navigationShell),
          ),

          /// Teacher navigation
          StatefulShellRoute.indexedStack(
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    name: 'teacherCourses',
                    path: '/teacher_courses',
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
                        name: 'teacherCourseDetails',
                        path: 'teacher_course_details',
                        builder: (context, state) {
                          final course = state.extra! as Course;

                          return CourseDetailPage(courseDetails: course);
                        },
                        routes: [
                          GoRoute(
                            name: 'teacherAssignments',
                            path: 'teacher_assignments/:courseId',
                            builder: (ctx, state) {
                              final courseId =
                                  state.pathParameters['courseId']!;

                              return AssignmentsPage(courseId: courseId);
                            },
                            routes: [
                              GoRoute(
                                name: 'teacherTasks',
                                path: 'teacher_tasks/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;

                                  return TasksPage(
                                    assignmentId: assignmentId,
                                  );
                                },
                              ),
                              GoRoute(
                                name: 'teacherCourseStudentEvaluateAnswers',
                                path:
                                    'teacher_course_student_evaluate_answers/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;
                                  final answer = state.extra! as StudentAnswer;

                                  return EvaluateTasksPage(
                                    assignmentId: assignmentId,
                                    title:
                                        '${answer.name.secondName} ${answer.name.firstName}. ${answer.name.middleName}.',
                                    userId: answer.userId,
                                  );
                                },
                              ),
                              GoRoute(
                                name: 'teacherCourseAnswerAssignment',
                                path:
                                    'teacher_course_answer_assignment/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;
                                  final title = state.extra! as String;

                                  return AnswerTasksPage(
                                    assignmentId: assignmentId,
                                    title: title,
                                  );
                                },
                              ),
                            ],
                          ),
                          GoRoute(
                            name: 'teacherAnswers',
                            path: 'teacher_answers/:courseId',
                            builder: (ctx, state) {
                              final courseId =
                                  state.pathParameters['courseId']!;

                              return TeacherAssignmentAnswersPage(
                                  courseId: courseId);
                            },
                            routes: [
                              GoRoute(
                                name: 'teacherEvaluateAnswers',
                                path: 'teacher_evaluate_answers/:assignmentId',
                                builder: (ctx, state) {
                                  final assignmentId =
                                      state.pathParameters['assignmentId']!;
                                  final answer = state.extra! as StudentAnswer;

                                  return EvaluateTasksPage(
                                    assignmentId: assignmentId,
                                    title:
                                        '${answer.name.secondName} ${answer.name.firstName}. ${answer.name.middleName}.',
                                    userId: answer.userId,
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
                    name: 'teacherProfile',
                    path: '/teacher_profile',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const ProfilePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                      transitionDuration: _defaultFadeTransitionDuration,
                      reverseTransitionDuration: _defaultFadeTransitionDuration,
                    ),
                    routes: [
                      GoRoute(
                        name: 'teacherEdit',
                        path: 'teacher_edit',
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
                TeacherRootScreen(navigationShell: navigationShell),
          ),

          /// Admin navigation
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
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
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
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
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
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                      transitionDuration: _defaultFadeTransitionDuration,
                      reverseTransitionDuration: _defaultFadeTransitionDuration,
                    ),
                    routes: [
                      GoRoute(
                        name: 'adminEdit',
                        path: 'admin_edit',
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
