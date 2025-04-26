import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/widget/custom_search_field.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_bloc.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_bloc_event.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_bloc_state.dart';
import 'package:learning_platform/src/feature/admin/data/data_source/admin_data_source.dart';
import 'package:learning_platform/src/feature/admin/data/repository/admin_repository.dart';
import 'package:learning_platform/src/feature/courses/widget/components/delete_course_dialog.dart';
import 'package:learning_platform/src/feature/courses/widget/components/edit_course_dialog.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class CoursesManagePage extends StatefulWidget {
  const CoursesManagePage({super.key});

  @override
  State<CoursesManagePage> createState() => _CoursesManagePageState();
}

class _CoursesManagePageState extends State<CoursesManagePage> {
  late final AdminCoursesBloc _adminBloc;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _adminBloc = AdminCoursesBloc(
      repository: AdminRepository(
        dataSource: AdminDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(const AdminCoursesBlocEvent.fetchCourses(searchQuery: ''));
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _adminBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Управление курсами'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomSearchField(
                hintText: 'Поиск',
                controller: _searchController,
                onChanged: (q) => _adminBloc
                    .add(AdminCoursesBlocEvent.fetchCourses(searchQuery: q)),
              ),
            ),
            Expanded(
              child: BlocBuilder<AdminCoursesBloc, AdminCoursesBlocState>(
                bloc: _adminBloc,
                builder: (context, state) => switch (state) {
                  Idle() => ListView.separated(
                      itemCount: state.courses.length,
                      separatorBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(color: Colors.blue, height: 1),
                      ),
                      itemBuilder: (context, i) {
                        final course = state.courses[i];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (course.isActive)
                                      TextButton(
                                        onPressed: () => _adminBloc.add(
                                          AdminCoursesBlocEvent.editCourse(
                                            courseId: course.id,
                                            name: course.name,
                                            description: course.description,
                                          ),
                                        ),
                                        child: const Text(
                                          'Деактивировать',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      )
                                    else
                                      TextButton(
                                        onPressed: () => _adminBloc.add(
                                          AdminCoursesBlocEvent.editCourse(
                                            courseId: course.id,
                                            name: course.name,
                                            description: course.description,
                                          ),
                                        ),
                                        child: const Text(
                                          'Активировать',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    TextButton(
                                      onPressed: () => DeleteCourseDialog(
                                        onTapCallback: () => _adminBloc.add(
                                          AdminCoursesBlocEvent.deleteCourse(
                                            courseId: course.id,
                                          ),
                                        ),
                                      ).show(context),
                                      child: const Text(
                                        'Удалить',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 16),
                                      onPressed: () => EditCourseDialog(
                                        onSaveCallback: (name, desc) =>
                                            _adminBloc.add(
                                          AdminCoursesBlocEvent.editCourse(
                                            courseId: course.id,
                                            name: name,
                                            description: desc,
                                          ),
                                        ),
                                        initialName: course.name,
                                        initialDescription: course.description,
                                      ).show(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  _ =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                },
              ),
            ),
          ],
        ),
      );
}
