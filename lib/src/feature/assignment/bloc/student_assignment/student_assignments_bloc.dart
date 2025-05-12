import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/student_assignment/student_assignments_state.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/i_assignment_repository.dart';

class StudentAssignmentsBloc extends Bloc<StudentAssignmentsEvent, StudentAssignmentsState> {
  final IAssignmentRepository _repo;

  StudentAssignmentsBloc({required IAssignmentRepository repo})
      : _repo = repo,
        super(const StudentAssignmentsState.idle(items: [])) {
    on<StudentAssignmentsEvent>(
      (event, emit) => switch (event) {
        StudentAssignmentsEvent$Fetch() => _onFetch(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    StudentAssignmentsEvent event,
    Emitter<StudentAssignmentsState> emit,
  ) async {
    emit(StudentAssignmentsState.loading(items: state.items));
    try {
      final items = await _repo.fetchAssignments();
      emit(StudentAssignmentsState.idle(items: items));
    } catch (e) {
      emit(
        StudentAssignmentsState.error(
          error: 'Ошибка загрузки заданий',
          items: state.items,
          event: event,
        ),
      );
    }
  }
}
