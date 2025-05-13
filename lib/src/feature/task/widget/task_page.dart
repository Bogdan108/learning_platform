import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/common/widget/custom_error_widget.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc_event.dart';
import 'package:learning_platform/src/feature/task/bloc/tasks_bloc/tasks_bloc_state.dart';
import 'package:learning_platform/src/feature/task/data/data_source/tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';
import 'package:learning_platform/src/feature/task/widget/components/create_task_dialog.dart';
import 'package:learning_platform/src/feature/task/widget/components/delete_task_dialog.dart';
import 'package:learning_platform/src/feature/task/widget/components/task_tile.dart';

class TasksPage extends StatefulWidget {
  final String assignmentId;
  const TasksPage({required this.assignmentId, super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late final TasksBloc _tasksBloc;
  late final TasksRepository tasksRepository;
  late final ScrollController _scrollController;
  final _scrollThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    tasksRepository = TasksRepository(
      dataSource: TasksDataSource(dio: deps.dio),
      tokenStorage: deps.tokenStorage,
      orgIdStorage: deps.organizationIdStorage,
    );
    _tasksBloc = TasksBloc(
      tasksRepository: tasksRepository,
    )..add(TasksBlocEvent.fetch(widget.assignmentId));
    _scrollController = ScrollController()..addListener(_handleRefresh);
  }

  void _handleRefresh() {
    final pos = _scrollController.position;
    if (pos.pixels < pos.minScrollExtent - _scrollThreshold && _tasksBloc.state is! Loading) {
      _tasksBloc.add(
        TasksBlocEvent.fetch(
          widget.assignmentId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Задачи')),
        body: BlocBuilder<TasksBloc, TasksBlocState>(
            bloc: _tasksBloc,
            builder: (_, state) => switch (state) {
                  Error() => CustomErrorWidget(
                      errorMessage: state.error,
                      onRetry: state.event != null ? () => _tasksBloc.add(state.event!) : null,
                    ),
                  _ => Stack(children: [
                      ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(color: Colors.blue, height: 1),
                        ),
                        itemCount: state.tasks.length + 1,
                        itemBuilder: (_, index) {
                          if (index == state.tasks.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CustomElevatedButton(
                                  title: 'Добавить задачу',
                                  onPressed: () {
                                    CreateTaskDialog(
                                      onSave: ({
                                        required QuestionType questionType,
                                        required AnswerType answerType,
                                        String? questionText,
                                        List<String>? answerVariants,
                                        Uint8List? questionFile,
                                        String? filename,
                                      }) {
                                        final req = TaskRequest(
                                          questionType: questionType,
                                          questionText: questionText,
                                          answerType: answerType,
                                          answerVariants: answerVariants,
                                        );
                                        _tasksBloc.add(
                                          TasksBlocEvent.create(
                                            assignmentId: widget.assignmentId,
                                            req: req,
                                            file: questionFile,
                                            name: filename,
                                          ),
                                        );
                                      },
                                    ).show(context);
                                  },
                                ),
                              ),
                            );
                          }
                          final task = state.tasks[index];

                          return TaskTile(
                            number: index + 1,
                            task: task,
                            tasksRepository: tasksRepository,
                            onDeleteTask: () => DeleteTaskDialog(
                              onTapCallback: () => _tasksBloc.add(
                                TasksBlocEvent.delete(task.id, widget.assignmentId),
                              ),
                            ).show(context),
                          );
                        },
                      ),
                      if (state is Loading)
                        const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                    ]),
                }),
      );
}
