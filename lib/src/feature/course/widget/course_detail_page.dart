// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/common/widget/custom_snackbar.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_event.dart';
import 'package:learning_platform/src/feature/course/bloc/course_bloc_state.dart'
    as course_state;
import 'package:learning_platform/src/feature/course/data/data_source/course_data_source.dart';
import 'package:learning_platform/src/feature/course/data/repository/course_repository.dart';
import 'package:learning_platform/src/feature/course/widget/components/add_addition_dialog.dart';
import 'package:learning_platform/src/feature/course/widget/components/delete_course_addition.dart';
import 'package:learning_platform/src/feature/course/widget/components/exit_course_dialog.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late final CourseRepository _courseRepository;

  @override
  void initState() {
    super.initState();

    final depsScope = DependenciesScope.of(context);
    _courseRepository = CourseRepository(
      dataSource: CourseDataSource(dio: depsScope.dio),
      tokenStorage: depsScope.tokenStorage,
      orgIdStorage: depsScope.organizationIdStorage,
    );
    _courseBloc = CourseBloc(
      courseRepository: _courseRepository,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Материалы к курсу',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      if (isTeacher)
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => AddAdditionDialog(
                            onLinkSave: ({required type, required link}) =>
                                _courseBloc.add(
                              CourseBlocEvent.addLinkAddition(
                                courseId: widget.courseDetails.id,
                                link: link,
                              ),
                            ),
                            onFileSave: ({required type, file}) {
                              _courseBloc.add(
                                CourseBlocEvent.uploadMaterial(
                                  courseId: widget.courseDetails.id,
                                  file: file,
                                ),
                              );
                            },
                          ).show(context),
                        ),
                    ],
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
                          /// Материалы файлы
                          for (final material
                              in courseState.additions.materials)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Expanded(child: Text(material.name)),
                                  const SizedBox(width: 10),

                                  /// Скачивание файла
                                  GestureDetector(
                                    child: const Icon(Icons.download),
                                    onTap: () async {
                                      CustomSnackBar.showSuccessful(
                                        context,
                                        title: 'Скачиваем ${material.name}...',
                                      );

                                      try {
                                        final filePath = await _courseRepository
                                            .downloadMaterial(
                                          widget.courseDetails.id,
                                          material.name,
                                          material.id,
                                        );

                                        final params = ShareParams(
                                          title: material.name,
                                          files: [XFile(filePath)],
                                        );

                                        await SharePlus.instance.share(params);
                                      } catch (e) {
                                        CustomSnackBar.showError(
                                          context,
                                          title: 'Ошибка: $e',
                                        );
                                      }
                                    },
                                  ),
                                  if (isTeacher)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: GestureDetector(
                                        child: const Icon(Icons.delete),
                                        onTap: () => DeleteCourseAdditionDialog(
                                          onTapCallback: () => _courseBloc.add(
                                            CourseBlocEvent.deleteAddition(
                                              courseId: widget.courseDetails.id,
                                              additionType: 'material',
                                              additionId: material.id,
                                            ),
                                          ),
                                        ).show(context),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                          /// Материалы ссылки
                          for (final link in courseState.additions.links)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final uri = Uri.parse(link.name);

                                        try {
                                          await launchUrl(
                                            uri,
                                          );
                                        } catch (e, _) {
                                          CustomSnackBar.showError(
                                            context,
                                            title: 'Ошибка открытия ссылки',
                                          );
                                        }
                                      },
                                      child: Text(
                                        link.name,
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isTeacher)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: GestureDetector(
                                        child: const Icon(Icons.delete),
                                        onTap: () => DeleteCourseAdditionDialog(
                                          onTapCallback: () => _courseBloc.add(
                                            CourseBlocEvent.deleteAddition(
                                              courseId: widget.courseDetails.id,
                                              additionType: 'link',
                                              additionId: link.id,
                                            ),
                                          ),
                                        ).show(context),
                                      ),
                                    ),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(
                      color: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.goNamed(
                      'assignments',
                      pathParameters: {
                        'courseId': widget.courseDetails.id,
                      },
                      extra: widget.courseDetails,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Задания',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => context.goNamed(
                      'answers',
                      pathParameters: {
                        'courseId': widget.courseDetails.id,
                      },
                      extra: widget.courseDetails,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ответы учеников',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
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
