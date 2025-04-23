// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_bloc.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_bloc_event.dart';
import 'package:learning_platform/src/feature/courses/bloc/courses_bloc_state.dart';
import 'package:learning_platform/src/feature/courses/data/data_source/courses_data_source.dart';
import 'package:learning_platform/src/feature/courses/data/repository/courses_repository.dart';
import 'package:learning_platform/src/feature/courses/widget/components/edit_course_dialog.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _TeacherCoursesPageState();
}

class _TeacherCoursesPageState extends State<CoursesPage> {
  late final CoursesBloc _coursesBloc;

  @override
  void initState() {
    super.initState();

    final depsScope = DependenciesScope.of(context);
    final profileRole = depsScope.profileBloc.state.profileInfo.role;
    _coursesBloc = CoursesBloc(
      coursesRepository: CoursesRepository(
        dataSource: CoursesDataSource(dio: depsScope.dio),
        tokenStorage: depsScope.tokenStorage,
        orgIdStorage: depsScope.organizationIdStorage,
      ),
    )..add(CoursesBlocEvent.fetchCourses(role: profileRole, searchQuery: ''));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Мои курсы'),
          centerTitle: true,
        ),
        body: BlocBuilder<CoursesBloc, CoursesBlocState>(
          bloc: _coursesBloc,
          builder: (context, state) => ListView.separated(
            itemCount: state.courses.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.blue,
              ),
            ),
            itemBuilder: (context, index) {
              final course = state.courses[index];
              return GestureDetector(
                onTap: () => context.go('/course_details', extra: course),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            course.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            course.isActive ? 'Активен' : 'Неактивен',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              course.description,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () => {},
                                child: Text('Удалить'),
                              ),
                              IconButton(
                                onPressed: () => EditCourseDialog(
                                  onCancel: () => {},
                                  onSave: (_, __) => {},
                                ).show(context),
                                icon: Icon(Icons.edit),
                                iconSize: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   '${course.studentCount} учеников',
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => {},
        //   child: const Icon(Icons.add),
        // ),
      );
}
