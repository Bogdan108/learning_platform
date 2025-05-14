import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/widget/custom_error_widget.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_state.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/assignment_repository.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class TeacherAssignmentAnswersPage extends StatefulWidget {
  final String courseId;

  const TeacherAssignmentAnswersPage({
    required this.courseId,
    super.key,
  });

  @override
  State<TeacherAssignmentAnswersPage> createState() =>
      _TeacherAssignmentAnswersPageState();
}

class _TeacherAssignmentAnswersPageState
    extends State<TeacherAssignmentAnswersPage> {
  late final TeacherAssignmentAnswersBloc _teacherAssignmentAnswersBloc;
  late final ScrollController _scrollController;
  final _scrollThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _teacherAssignmentAnswersBloc = TeacherAssignmentAnswersBloc(
      repository: AssignmentRepository(
        dataSource: AssignmentDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(
        TeacherAssignmentAnswersEvent.fetch(
          courseId: widget.courseId,
        ),
      );
    _scrollController = ScrollController()..addListener(_handleRefresh);
  }

  @override
  void dispose() {
    _teacherAssignmentAnswersBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    final pos = _scrollController.position;
    if (pos.pixels < pos.minScrollExtent - _scrollThreshold &&
        _teacherAssignmentAnswersBloc.state
            is! TeacherAssignmentAnswersState$Loading) {
      _teacherAssignmentAnswersBloc.add(
        TeacherAssignmentAnswersEvent.fetch(
          courseId: widget.courseId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ответы учеников')),
        body: BlocBuilder<TeacherAssignmentAnswersBloc,
            TeacherAssignmentAnswersState>(
          bloc: _teacherAssignmentAnswersBloc,
          builder: (context, state) => switch (state) {
            TeacherAssignmentAnswersState$Error() => CustomErrorWidget(
                errorMessage: state.error,
                onRetry: state.event != null
                    ? () => _teacherAssignmentAnswersBloc.add(state.event!)
                    : null,
              ),
            _ => Stack(
                children: [
                  _AnswersList(
                    data: state.data,
                    courseId: widget.courseId,
                    scrollController: _scrollController,
                  ),
                  if (state is TeacherAssignmentAnswersState$Loading)
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                ],
              ),
          },
        ),
      );
}

class _AnswersList extends StatelessWidget {
  final String courseId;
  final List<AssignmentAnswers> data;
  final ScrollController scrollController;

  const _AnswersList({
    required this.data,
    required this.courseId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
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
                    'teacherEvaluateAnswers',
                    pathParameters: {
                      'assignmentId': answer.id,
                      'courseId': courseId,
                    },
                    extra: s,
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
                          s.isEvaluated
                              ? Icons.check_circle
                              : Icons.hourglass_top,
                          color: s.isEvaluated ? Colors.green : Colors.grey,
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
