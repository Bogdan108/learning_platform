import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/widget/custom_error_widget.dart';
import 'package:learning_platform/src/core/widget/custom_search_field.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_bloc.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_event.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_state.dart';
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
  late final ScrollController _scrollController;
  final _scrollThreshold = 80.0;

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
    )..add(const AdminCoursesEvent.fetchCourses(searchQuery: ''));
    _searchController = TextEditingController()
      ..addListener(_handleTextEditing);
    _scrollController = ScrollController()..addListener(_handleRefresh);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _adminBloc.close();
    super.dispose();
  }

  void _handleRefresh() {
    final pos = _scrollController.position;
    if (pos.pixels < pos.minScrollExtent - _scrollThreshold &&
        _adminBloc.state is! AdminCoursesState$Loading) {
      final text = _searchController.text;
      _adminBloc.add(
        AdminCoursesEvent.fetchCourses(
          searchQuery: text.isNotEmpty ? text : null,
        ),
      );
    }
  }

  void _handleTextEditing() {
    final text = _searchController.text;
    _adminBloc.add(
      AdminCoursesEvent.fetchCourses(
          searchQuery: text.isNotEmpty ? text : null),
    );
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
              ),
            ),
            Expanded(
              child: BlocBuilder<AdminCoursesBloc, AdminCoursesState>(
                bloc: _adminBloc,
                builder: (context, state) => switch (state) {
                  AdminCoursesState$Error() => CustomErrorWidget(
                      errorMessage: state.error,
                      onRetry: state.event != null
                          ? () => _adminBloc.add(state.event!)
                          : null,
                    ),
                  _ => Stack(children: [
                      ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
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
                                      TextButton(
                                        onPressed: () => DeleteCourseDialog(
                                          onTapCallback: () => _adminBloc.add(
                                            AdminCoursesEvent.deleteCourse(
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
                                            AdminCoursesEvent.editCourse(
                                              courseId: course.id,
                                              name: name,
                                              description: desc,
                                            ),
                                          ),
                                          initialName: course.name,
                                          initialDescription:
                                              course.description,
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
                      if (state is AdminCoursesState$Loading)
                        const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                    ]),
                },
              ),
            ),
          ],
        ),
      );
}
