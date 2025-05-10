import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_state.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/assignment_repository.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_status.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class StudentAssignmentsPage extends StatefulWidget {
  const StudentAssignmentsPage({super.key});

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> {
  late final StudentAssignmentsBloc _bloc;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _bloc = StudentAssignmentsBloc(
      repo: AssignmentRepository(
        dataSource: AssignmentDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(
        const StudentAssignmentsEvent.fetch(),
      );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Задания по курсу'),
          centerTitle: true,
        ),
        body: BlocBuilder<StudentAssignmentsBloc, StudentAssignmentsState>(
          bloc: _bloc,
          builder: (context, state) {
            switch (state.runtimeType) {
              case const (StudentAssignmentsState$Loading):
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case StudentAssignmentsState$Error _:
                final errorState = state as StudentAssignmentsState$Error;
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ошибка: ${errorState.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      CustomElevatedButton(
                        onPressed: () => _bloc.add(
                          const StudentAssignmentsEvent.fetch(),
                        ),
                        title: 'Повторить',
                      ),
                    ],
                  ),
                );
              case const (StudentAssignmentsState$Idle):
                final idleState = state as StudentAssignmentsState$Idle;
                if (idleState.items.isEmpty) {
                  return const Center(child: Text('Нет заданий'));
                }
                return ListView(
                  children: [
                    for (final course in idleState.items) ...[
                      // Заголовок раздела
                      const Divider(
                        color: Colors.blue,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(
                          course.courseName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.blue,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      // Список заданий
                      for (final asg in course.assignments) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE2F2FF,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(
                                asg.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                              subtitle: Text(
                                asg.status.statusText,
                                style: TextStyle(
                                  color: asg.status.statusColor,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.blue,
                              ),
                              onTap: () {
                                if (asg.status == AssignmentStatus.pending) {
                                  context.pushNamed(
                                    'answerAssignment',
                                    pathParameters: {'assignmentId': asg.id},
                                    extra: asg.name,
                                  );
                                } else {
                                  context.pushNamed(
                                    'studentEvaluateAnswers',
                                    pathParameters: {'answerId': asg.id},
                                    extra: asg.name,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      );
}
