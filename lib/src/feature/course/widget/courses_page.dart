import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/core/widget/custom_error_widget.dart';
import 'package:learning_platform/src/core/widget/custom_search_field.dart';
import 'package:learning_platform/src/feature/course/bloc/courses_bloc.dart';
import 'package:learning_platform/src/feature/course/bloc/courses_event.dart';
import 'package:learning_platform/src/feature/course/bloc/courses_state.dart';
import 'package:learning_platform/src/feature/course/data/data_source/courses_data_source.dart';
import 'package:learning_platform/src/feature/course/data/repository/courses_repository.dart';
import 'package:learning_platform/src/feature/course/widget/components/create_course_dialog.dart';
import 'package:learning_platform/src/feature/course/widget/components/delete_course_dialog.dart';
import 'package:learning_platform/src/feature/course/widget/components/edit_course_dialog.dart';
import 'package:learning_platform/src/feature/course/widget/components/enroll_course_dialog.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _TeacherCoursesPageState();
}

class _TeacherCoursesPageState extends State<CoursesPage> {
  late final ProfileBloc _profileBloc;
  late final CoursesBloc _coursesBloc;
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  final _scrollThreshold = 80.0;

  @override
  void initState() {
    super.initState();

    final depsScope = DependenciesScope.of(context);

    _profileBloc = depsScope.profileBloc;
    final profileRole = _profileBloc.state.profileInfo.role;
    _coursesBloc = CoursesBloc(
      coursesRepository: CoursesRepository(
        dataSource: CoursesDataSource(dio: depsScope.dio),
        tokenStorage: depsScope.tokenStorage,
        orgIdStorage: depsScope.organizationIdStorage,
      ),
    )..add(CoursesEvent.fetchCourses(role: profileRole));
    _searchController = TextEditingController()
      ..addListener(_handleTextEditing);
    _scrollController = ScrollController()..addListener(_handleRefresh);
  }

  @override
  void dispose() {
    _coursesBloc.close();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    final pos = _scrollController.position;
    if (pos.pixels < pos.minScrollExtent - _scrollThreshold &&
        _coursesBloc.state is! CoursesState$Loading) {
      final profileRole = _profileBloc.state.profileInfo.role;

      final text = _searchController.text;
      _coursesBloc.add(
        CoursesEvent.fetchCourses(
          role: profileRole,
          searchQuery: text.isNotEmpty ? text : null,
        ),
      );
    }
  }

  void _handleTextEditing() {
    final profileRole = _profileBloc.state.profileInfo.role;
    final text = _searchController.text;

    _coursesBloc.add(
      CoursesEvent.fetchCourses(
        role: profileRole,
        searchQuery: text.isNotEmpty ? text : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfileBloc, ProfileBlocState>(
        bloc: _profileBloc,
        builder: (context, profileState) {
          final role = profileState.profileInfo.role;
          final isTeacher = role == UserRole.teacher;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Мои курсы'),
              centerTitle: true,
            ),
            body: BlocBuilder<CoursesBloc, CoursesState>(
              bloc: _coursesBloc,
              builder: (context, state) => switch (state) {
                CoursesState$Error() => CustomErrorWidget(
                    errorMessage: state.error,
                    onRetry: state.event != null
                        ? () => _coursesBloc.add(state.event!)
                        : null,
                  ),
                _ => Stack(children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomSearchField(
                            hintText: 'Поиск',
                            controller: _searchController,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: state.courses.length + 1,
                            padding: EdgeInsets.zero,
                            separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(color: Colors.blue, height: 1),
                            ),
                            itemBuilder: (context, index) {
                              if (index == state.courses.length) {
                                return isTeacher
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 24,
                                          ),
                                          child: CustomElevatedButton(
                                            title: 'Добавить курс',
                                            onPressed: () => CreateCourseDialog(
                                              onCreateCallBack:
                                                  (name, description) =>
                                                      _coursesBloc.add(
                                                CoursesEvent.createCourse(
                                                  name: name,
                                                  description: description,
                                                ),
                                              ),
                                            ).show(context),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 24,
                                          ),
                                          child: CustomElevatedButton(
                                            title: 'Записаться на курс',
                                            onPressed: () => EnrollCourseDialog(
                                              onEnrollCallBack: (
                                                name,
                                              ) =>
                                                  _coursesBloc.add(
                                                CoursesEvent.enrollCourse(
                                                  courseId: name,
                                                ),
                                              ),
                                            ).show(context),
                                          ),
                                        ),
                                      );
                              }

                              final course = state.courses[index];
                              return GestureDetector(
                                onTap: () {
                                  final profileRole =
                                      _profileBloc.state.profileInfo.role;
                                  context.goNamed(
                                    profileRole == UserRole.student
                                        ? 'courseDetails'
                                        : 'teacherCourseDetails',
                                    extra: course,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          // Text(
                                          //   course.isActive ? 'Активен' : 'Неактивен',
                                          //   style: const TextStyle(
                                          //     fontSize: 14,
                                          //     color: Colors.blue,
                                          //   ),
                                          //),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        course.description,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      if (isTeacher)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    DeleteCourseDialog(
                                                  onTapCallback: () =>
                                                      _coursesBloc.add(
                                                    CoursesEvent.deleteCourse(
                                                      courseId: course.id,
                                                    ),
                                                  ),
                                                ).show(context),
                                                child: const Text(
                                                  'Удалить',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    EditCourseDialog(
                                                  initialName: course.name,
                                                  initialDescription:
                                                      course.description,
                                                  onSaveCallback:
                                                      (name, description) =>
                                                          _coursesBloc.add(
                                                    CoursesEvent.editCourse(
                                                      courseId: course.id,
                                                      name: name,
                                                      description: description,
                                                    ),
                                                  ),
                                                ).show(context),
                                                icon: const Icon(Icons.edit,
                                                    size: 15),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        const SizedBox(
                                          height: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (state is CoursesState$Loading)
                      const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                  ]),
              },
            ),
          );
        },
      );
}
