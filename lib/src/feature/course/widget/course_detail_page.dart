import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_event.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_state.dart'
    as course_state;
import 'package:learning_platform/src/feature/course/data/data_source/course_data_source.dart';
import 'package:learning_platform/src/feature/course/data/repository/course_repository.dart';
import 'package:learning_platform/src/feature/course/widget/components/exit_course_dialog.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class CourseDetailPage extends StatefulWidget {
  final Course courseDetails;

  const CourseDetailPage({
    required this.courseDetails,
    super.key,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late final CourseBloc _courseBloc;

  @override
  void initState() {
    super.initState();

    final depsScope = DependenciesScope.of(context);
    _courseBloc = CourseBloc(
      courseRepository: CourseRepository(
        dataSource: CourseDataSource(dio: depsScope.dio),
        tokenStorage: depsScope.tokenStorage,
        orgIdStorage: depsScope.organizationIdStorage,
      ),
    )..add(
        CourseBlocEvent.fetchCourseAdditions(
          courseId: widget.courseDetails.id,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = DependenciesScope.of(context).profileBloc;

    return BlocBuilder<ProfileBloc, ProfileBlocState>(
      bloc: profileBloc,
      builder: (context, profileState) {
        final role = profileState.profileInfo.role;
        final isTeacher = role == UserRole.teacher;
        final isStudent = role == UserRole.student;

        return BlocBuilder<CourseBloc, course_state.CourseBlocState>(
          bloc: _courseBloc,
          builder: (context, courseState) => Scaffold(
            appBar: AppBar(
              title: Text(widget.courseDetails.name),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.courseDetails.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(
                      color: Colors.blue,
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Материалы к курсу',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.add),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final link in courseState.additions.links)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            link.name,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.download,
                          ),
                        ],
                      ),
                    ),
                  Column(
                    children: switch (courseState) {
                      course_state.Loading() => [
                          const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        ],
                      _ => [
                          for (final material
                              in courseState.additions.materials)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Expanded(child: Text(material.name)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.download),
                                ],
                              ),
                            ),
                        ],
                    },
                  ),
                  if (isTeacher) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      'Ученики',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: switch (courseState) {
                        course_state.Loading() => [
                            const Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                          ],
                        _ => [
                            for (final student in courseState.students)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '${student.fullName.fullName.secondName} ${student.fullName.fullName.firstName} ${student.fullName.fullName.middleName}',
                                ),
                              ),
                          ],
                      },
                    ),
                  ],
                  const SizedBox(
                    height: 30,
                  ),
                  // TODO(b.luckyanchuk): Add exit from course event
                  if (isStudent)
                    TextButton(
                      onPressed: () => ExitCourseDialog(
                        onTapCallback: () => {
                          context.pop(),
                        },
                      ).show(context),
                      child: const Text(
                        'Выйти из курса',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
