import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/widget/custom_error_widget.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_tasks_bloc/evaluate_assignment_bloc.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_tasks_bloc/evaluate_tasks_event.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_tasks_bloc/evaluate_tasks_state.dart';
import 'package:learning_platform/src/feature/task/data/data_source/tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/widget/components/evaluate_task_tile.dart';

class EvaluateTasksPage extends StatefulWidget {
  final String assignmentId;
  final String title;
  final String? userId;

  const EvaluateTasksPage({
    required this.assignmentId,
    required this.title,
    this.userId,
    super.key,
  });

  @override
  State<EvaluateTasksPage> createState() => _EvaluateTasksPageState();
}

class _EvaluateTasksPageState extends State<EvaluateTasksPage> {
  late final EvaluateTasksBloc _bloc;
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

    _bloc = EvaluateTasksBloc(
      tasksRepository: tasksRepository,
    )..add(
        widget.userId == null
            ? EvaluateTasksEvent.studentFetch(
                assignmentId: widget.assignmentId,
              )
            : EvaluateTasksEvent.teacherFetch(
                userId: widget.userId!,
                assignmentId: widget.assignmentId,
              ),
      );
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _bloc,
        child: Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: BlocBuilder<EvaluateTasksBloc, EvaluateTasksState>(
            bloc: _bloc,
            builder: (_, state) => switch (state) {
              EvaluateTasksState$Error() => CustomErrorWidget(
                  errorMessage: state.message,
                  onRetry: state.event != null
                      ? () => _bloc.add(state.event!)
                      : null,
                ),
              _ => Stack(
                  children: [
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(color: Colors.blue, height: 1),
                      ),
                      itemCount: state.evaluateAnswers.taksInfo.length,
                      itemBuilder: (_, index) {
                        final task = state.evaluateAnswers.taksInfo[index];

                        return EvaluateTaskTile(
                          number: index + 1,
                          task: task,
                          tasksRepository: tasksRepository,
                          userId: widget.userId,
                          assignmentId: widget.assignmentId,
                        );
                      },
                    ),
                    if (state is EvaluateTasksState$Loading)
                      const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                  ],
                ),
            },
          ),
        ),
      );
}
