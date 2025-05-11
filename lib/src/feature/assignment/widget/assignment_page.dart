import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_bloc_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_bloc_state.dart'
    as assignment;
import 'package:learning_platform/src/feature/assignment/data/data_source/assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/assignment_repository.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_status.dart';
import 'package:learning_platform/src/feature/assignment/widget/components/assignment_tile.dart';
import 'package:learning_platform/src/feature/assignment/widget/components/create_edit_assignment_dialog.dart';
import 'package:learning_platform/src/feature/assignment/widget/components/delete_assignment_addition.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class AssignmentsPage extends StatefulWidget {
  final String courseId;
  const AssignmentsPage({required this.courseId, super.key});

  @override
  State<AssignmentsPage> createState() => _State();
}

class _State extends State<AssignmentsPage> {
  late final AssignmentBloc _assignmentBloc;

  @override
  void initState() {
    super.initState();
    final depsScope = DependenciesScope.of(context);
    _assignmentBloc = AssignmentBloc(
      repo: AssignmentRepository(
        dataSource: AssignmentDataSource(dio: depsScope.dio),
        tokenStorage: depsScope.tokenStorage,
        orgIdStorage: depsScope.organizationIdStorage,
      ),
    )..add(AssignmentBlocEvent.fetch(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext ctx) {
    final profileBloc = DependenciesScope.of(context).profileBloc;

    return BlocBuilder<ProfileBloc, ProfileBlocState>(
      bloc: profileBloc,
      builder: (context, profileState) {
        final role = profileState.profileInfo.role;
        final isTeacher = role == UserRole.teacher;

        return Scaffold(
          appBar: AppBar(title: const Text('Задания'), centerTitle: true),
          body: BlocBuilder<AssignmentBloc, assignment.AssignmentBlocState>(
            bloc: _assignmentBloc,
            builder: (context, state) => switch (state) {
              assignment.Loading() => const Center(child: CircularProgressIndicator()),
              assignment.Idle(items: final items) ||
              assignment.Error(items: final items, error: _) =>
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: isTeacher ? items.length + 1 : items.length,
                  itemBuilder: (_, index) {
                    if (index == items.length) {
                      return Center(
                        child: CustomElevatedButton(
                          onPressed: () => CreateEditAssignmentDialog(
                            title: 'Добавить задание',
                            onSave: (req) => _assignmentBloc.add(
                              AssignmentBlocEvent.create(
                                courseId: widget.courseId,
                                request: req,
                              ),
                            ),
                          ).show(ctx),
                          title: 'Добавить задание',
                        ),
                      );
                    }
                    final assignment = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: AssignmentTile(
                        assignment: assignment,
                        trailing: Row(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isTeacher) ...[
                              GestureDetector(
                                child: const Icon(Icons.edit),
                                onTap: () => CreateEditAssignmentDialog(
                                  title: 'Редактировать задание',
                                  initialName: assignment.name,
                                  initialStart: assignment.startedAt,
                                  initialEnd: assignment.endedAt,
                                  onSave: (req) => _assignmentBloc.add(
                                    AssignmentBlocEvent.edit(
                                      assignmentId: assignment.id,
                                      courseId: widget.courseId,
                                      request: req,
                                    ),
                                  ),
                                ).show(ctx),
                              ),
                              GestureDetector(
                                child: const Icon(Icons.delete, color: Colors.red),
                                onTap: () => DeleteAssignmentDialog(
                                  onTapCallback: () => _assignmentBloc.add(
                                    AssignmentBlocEvent.delete(
                                      assignmentId: assignment.id,
                                      courseId: widget.courseId,
                                    ),
                                  ),
                                ).show(context),
                              ),
                            ],
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        onTap: () {
                          if (isTeacher) {
                            context.pushNamed(
                              'tasks',
                              pathParameters: {
                                'courseId': widget.courseId,
                                'assignmentId': assignment.id,
                              },
                            );
                          } else {
                            {
                              if (assignment.status == AssignmentStatus.pending) {
                                context.pushNamed(
                                  'answerAssignment',
                                  pathParameters: {'assignmentId': assignment.id},
                                  extra: assignment.name,
                                );
                              } else {
                                context.pushNamed(
                                  'studentEvaluateAnswers',
                                  pathParameters: {'answerId': assignment.id},
                                  extra: assignment.name,
                                );
                              }
                            }
                          }
                        },
                      ),
                    );
                  },
                )
            },
          ),
        );
      },
    );
  }
}
