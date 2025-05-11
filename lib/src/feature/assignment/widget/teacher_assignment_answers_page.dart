import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_state.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/assignment_repository.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class AssignmentAnswersPage extends StatefulWidget {
  final String courseId;
  const AssignmentAnswersPage({required this.courseId, super.key});

  @override
  State<AssignmentAnswersPage> createState() => _AssignmentAnswersPageState();
}

class _AssignmentAnswersPageState extends State<AssignmentAnswersPage> {
  late final TeacherAssignmentAnswersBloc _bloc;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _bloc = TeacherAssignmentAnswersBloc(
      repository: AssignmentRepository(
        dataSource: AssignmentDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(TeacherAssignmentAnswersEvent.fetch(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ответы учеников')),
        body: BlocBuilder<TeacherAssignmentAnswersBloc, TeacherAssignmentAnswersState>(
          bloc: _bloc,
          builder: (context, state) {
            switch (state) {
              case TeacherAssignmentAnswersState$Loading():
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
              case TeacherAssignmentAnswersState$Error():
                return _ErrorView(
                  message: state.error,
                  onRetry: () => _bloc.add(
                    TeacherAssignmentAnswersEvent.fetch(courseId: widget.courseId),
                  ),
                );
              case TeacherAssignmentAnswersState$Idle():
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    extra: '${s.name.secondName} ${s.name.firstName}. ${s.name.middleName}.',
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
                          s.evaluated ? Icons.check_circle : Icons.hourglass_top,
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
