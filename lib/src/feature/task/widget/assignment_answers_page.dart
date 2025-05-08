import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/task/bloc/assignment_answers_bloc/assignment_answers_bloc.dart';
import 'package:learning_platform/src/feature/task/bloc/assignment_answers_bloc/assignment_answers_event.dart';
import 'package:learning_platform/src/feature/task/bloc/assignment_answers_bloc/assignment_answers_state.dart';
import 'package:learning_platform/src/feature/task/data/data_source/tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/assignment_answers.dart';

class AssignmentAnswersPage extends StatefulWidget {
  final String courseId;
  const AssignmentAnswersPage({required this.courseId, super.key});

  @override
  State<AssignmentAnswersPage> createState() => _AssignmentAnswersPageState();
}

class _AssignmentAnswersPageState extends State<AssignmentAnswersPage> {
  late final AssignmentAnswersBloc _bloc;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _bloc = AssignmentAnswersBloc(
      repo: TasksRepository(
        dataSource: TasksDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(AssignmentAnswersEvent.fetch(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ответы учеников')),
        body: BlocBuilder<AssignmentAnswersBloc, AssignmentAnswersState>(
          bloc: _bloc,
          builder: (context, state) {
            switch (state) {
              case AssignmentAnswersState$Loading():
                return Stack(
                  children: [
                    _AnswersList(
                      data: state.data,
                      courseId: widget.courseId,
                    ),
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ],
                );
              case AssignmentAnswersState$Error():
                return _ErrorView(
                  message: state.error,
                  onRetry: () => _bloc.add(
                    AssignmentAnswersEvent.fetch(courseId: widget.courseId),
                  ),
                );
              case AssignmentAnswersState$Idle():
                if (state.data.isEmpty) {
                  return const Center(child: Text('Пока нет ответов'));
                }
                return Stack(
                  children: [
                    _AnswersList(
                      data: state.data,
                      courseId: widget.courseId,
                    ),
                  ],
                );
            }
          },
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

class _AnswersList extends StatelessWidget {
  final String courseId;
  final List<AssignmentAnswers> data;

  const _AnswersList({
    required this.data,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: data.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (_, idx) {
          final answer = data[idx];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  answer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Divider(color: Colors.blue),
              const SizedBox(height: 6),
              for (final s in answer.students)
                GestureDetector(
                  onTap: () => context.pushNamed(
                    'evaluateAnswers',
                    pathParameters: {
                      'answerId': s.answerId,
                      'courseId': courseId,
                    },
                    extra:
                        '${s.name.secondName} ${s.name.firstName}. ${s.name.middleName}.',
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${s.name.secondName} ${s.name.firstName}. ${s.name.middleName}.',
                          ),
                        ),
                        Icon(
                          s.evaluated
                              ? Icons.check_circle
                              : Icons.hourglass_top,
                          color: s.evaluated ? Colors.green : Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      );
}
