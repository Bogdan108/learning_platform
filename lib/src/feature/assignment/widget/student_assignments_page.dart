import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/widget/custom_error_widget.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_state.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/assignment_repository.dart';
import 'package:learning_platform/src/feature/assignment/widget/components/student_assignment_widget.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class StudentAssignmentsPage extends StatefulWidget {
  const StudentAssignmentsPage({super.key});

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> {
  late final StudentAssignmentsBloc _studentAssignmentsBloc;
  late final ScrollController _scrollController;
  final _scrollThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _studentAssignmentsBloc = StudentAssignmentsBloc(
      repo: AssignmentRepository(
        dataSource: AssignmentDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(
        const StudentAssignmentsEvent.fetch(),
      );

    _scrollController = ScrollController()..addListener(_handleRefresh);
  }

  @override
  void dispose() {
    _studentAssignmentsBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    final pos = _scrollController.position;
    if (pos.pixels < pos.minScrollExtent - _scrollThreshold &&
        _studentAssignmentsBloc.state is! StudentAssignmentsState$Loading) {
      _studentAssignmentsBloc.add(
        const StudentAssignmentsEvent.fetch(),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Задания по курсу'),
          centerTitle: true,
        ),
        body: BlocBuilder<StudentAssignmentsBloc, StudentAssignmentsState>(
          bloc: _studentAssignmentsBloc,
          builder: (context, state) => switch (state) {
            StudentAssignmentsState$Error() => CustomErrorWidget(
                errorMessage: state.error,
                onRetry:
                    state.event != null ? () => _studentAssignmentsBloc.add(state.event!) : null,
              ),
            _ => Stack(children: [
                ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    for (final course in state.items)
                      StudentAssignmentWidget(
                        course: course,
                      )
                  ],
                ),
                if (state is StudentAssignmentsState$Loading)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
              ]),
          },
        ),
      );
}
