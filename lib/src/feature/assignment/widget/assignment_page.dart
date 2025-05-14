import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/core/widget/custom_error_widget.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_state.dart';
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
  late final ScrollController _scrollController;
  final _scrollThreshold = 80.0;

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
    )..add(AssignmentEvent.fetch(courseId: widget.courseId));
    _scrollController = ScrollController()..addListener(_handleRefresh);
  }

  void _handleRefresh() {
    final pos = _scrollController.position;
    if (pos.pixels < pos.minScrollExtent - _scrollThreshold &&
        _assignmentBloc.state is! AssignmentState$Loading) {
      _assignmentBloc.add(
        AssignmentEvent.fetch(courseId: widget.courseId),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _assignmentBloc.close();
    super.dispose();
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
          body: BlocBuilder<AssignmentBloc, AssignmentState>(
            bloc: _assignmentBloc,
            builder: (context, state) => switch (state) {
              AssignmentState$Error() => CustomErrorWidget(
                  errorMessage: state.error,
                  onRetry: state.event != null
                      ? () => _assignmentBloc.add(state.event!)
                      : null,
                ),
              _ => Stack(children: [
                  ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount:
                        isTeacher ? state.items.length + 1 : state.items.length,
                    itemBuilder: (_, index) {
                      if (index == state.items.length) {
                        return Center(
                          child: CustomElevatedButton(
                            onPressed: () => CreateEditAssignmentDialog(
                              title: 'Добавить задание',
                              onSave: (req) => _assignmentBloc.add(
                                AssignmentEvent.create(
                                  courseId: widget.courseId,
                                  request: req,
                                ),
                              ),
                            ).show(ctx),
                            title: 'Добавить задание',
                          ),
                        );
                      }
                      final assignment = state.items[index];
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
                                      AssignmentEvent.edit(
                                        assignmentId: assignment.id,
                                        courseId: widget.courseId,
                                        request: req,
                                      ),
                                    ),
                                  ).show(ctx),
                                ),
                                GestureDetector(
                                  child: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onTap: () => DeleteAssignmentDialog(
                                    onTapCallback: () => _assignmentBloc.add(
                                      AssignmentEvent.delete(
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
                                'teacherTasks',
                                pathParameters: {
                                  'courseId': widget.courseId,
                                  'assignmentId': assignment.id,
                                },
                              );
                            } else {
                              {
                                if (assignment.status ==
                                    AssignmentStatus.pending) {
                                  context.pushNamed(
                                    'answerAssignment',
                                    pathParameters: {
                                      'assignmentId': assignment.id
                                    },
                                    extra: assignment.name,
                                  );
                                } else {
                                  context.pushNamed(
                                    'studentEvaluateAnswers',
                                    pathParameters: {
                                      'assignmentId': assignment.id
                                    },
                                    extra: assignment.name,
                                  );
                                }
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                  if (state is AssignmentState$Loading)
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                ])
            },
          ),
        );
      },
    );
  }
}
