import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/task/bloc/answers_info_bloc/answers_info_bloc.dart';
import 'package:learning_platform/src/feature/task/bloc/answers_info_bloc/answers_info_bloc_event.dart';
import 'package:learning_platform/src/feature/task/bloc/answers_info_bloc/answers_info_bloc_state.dart';
import 'package:learning_platform/src/feature/task/data/data_source/tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/assignment_answers.dart';

class AnswersPage extends StatefulWidget {
  final String courseId;
  const AnswersPage({required this.courseId, super.key});

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  late final AnswersInfoBloc _bloc;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _bloc = AnswersInfoBloc(
      repo: TasksRepository(
        dataSource: TasksDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(AnswersInfoBlocEvent.fetch(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ответы учеников')),
        body: BlocBuilder<AnswersInfoBloc, AnswersInfoBlocState>(
          bloc: _bloc,
          builder: (context, state) {
            switch (state) {
              case Loading():
                return Stack(
                  children: [
                    _AnswersList(data: state.data),
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ],
                );
              case Error():
                return _ErrorView(
                  message: state.error,
                  onRetry: () => _bloc.add(
                    AnswersInfoBlocEvent.fetch(courseId: widget.courseId),
                  ),
                );
              case Idle():
                if (state.data.isEmpty) {
                  return const Center(child: Text('Пока нет ответов'));
                }
                return Stack(
                  children: [
                    _AnswersList(data: state.data),
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
  final List<AssignmentAnswers> data;
  const _AnswersList({required this.data});

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: data.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (_, idx) {
          final a = data[idx];
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
                  a.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Divider(color: Colors.blue),
              const SizedBox(height: 6),
              for (final s in a.students)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${s.name.secondName} ${s.name.firstName}. ${s.name.middleName}.',
                        ),
                      ),
                      Icon(
                        s.evaluated ? Icons.check_circle : Icons.hourglass_top,
                        color: s.evaluated ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      );
}
