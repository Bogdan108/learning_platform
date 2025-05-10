import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_assignment_bloc/evaluate_assignment_bloc.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_assignment_bloc/evaluate_assignment_event.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_assignment_bloc/evaluate_assignment_state.dart';
import 'package:learning_platform/src/feature/task/data/data_source/tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/widget/components/evaluate_task_tile.dart';

class EvaluateAssignmentPage extends StatefulWidget {
  final String answerId;
  final String assignmentId;
  final String title;

  const EvaluateAssignmentPage({
    required this.answerId,
    required this.assignmentId,
    required this.title,
    super.key,
  });

  @override
  State<EvaluateAssignmentPage> createState() => _EvaluateAssignmentPageState();
}

class _EvaluateAssignmentPageState extends State<EvaluateAssignmentPage> {
  late final EvaluateAssignmentBloc _bloc;
  late final TasksRepository tasksRepository;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    tasksRepository = TasksRepository(
      dataSource: TasksDataSource(dio: deps.dio),
      tokenStorage: deps.tokenStorage,
      orgIdStorage: deps.organizationIdStorage,
    );
    _bloc = EvaluateAssignmentBloc(
      tasksRepository: tasksRepository,
    )..add(
        EvaluateAssignmentEvent.fetch(
          answerId: widget.answerId,
          assignmentId: widget.assignmentId,
        ),
      );
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _bloc,
        child: Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: BlocBuilder<EvaluateAssignmentBloc, EvaluateAssignmentState>(
            bloc: _bloc,
            builder: (_, state) {
              switch (state) {
                case EvaluateAssignmentState$Loading():
                  return Stack(
                    children: [
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(color: Colors.blue, height: 1),
                        ),
                        itemCount: state.evaluateAnswers.evaluateTasks.length,
                        itemBuilder: (_, index) {
                          final task =
                              state.evaluateAnswers.evaluateTasks[index];

                          return EvaluateTaskTile(
                            number: index + 1,
                            task: task,
                            tasksRepository: tasksRepository,
                            onDeleteTask: () => {},
                          );
                        },
                      ),
                      const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ],
                  );
                case EvaluateAssignmentState$Error():
                  return _ErrorView(
                    message: state.message,
                    onRetry: () => {},
                  );
                case EvaluateAssignmentState$Idle():
                  return Stack(
                    children: [
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(color: Colors.blue, height: 1),
                        ),
                        itemCount: state.evaluateAnswers.evaluateTasks.length,
                        itemBuilder: (_, index) {
                          final task =
                              state.evaluateAnswers.evaluateTasks[index];

                          return EvaluateTaskTile(
                            number: index + 1,
                            task: task,
                            tasksRepository: tasksRepository,
                            onDeleteTask: () => {},
                          );
                        },
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ошибка: $message', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              CustomElevatedButton(
                onPressed: onRetry,
                title: 'Повторить',
              ),
            ],
          ),
        ),
      );
}
