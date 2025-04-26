import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment_bloc_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment_bloc_state.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/i_assignment_repository.dart';

class AssignmentBloc extends Bloc<AssignmentBlocEvent, AssignmentBlocState> {
  final IAssignmentRepository _repo;

  AssignmentBloc({required IAssignmentRepository repo})
      : _repo = repo,
        super(const AssignmentBlocState.idle(items: [])) {
    on<AssignmentBlocEvent>(
      (event, emit) => switch (event) {
        FetchEvent() => _onFetch(event, emit),
        CreateEvent() => _onCreate(event, emit),
        EditEvent() => _onEdit(event, emit),
        DeleteEvent() => _onDelete(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    FetchEvent event,
    Emitter<AssignmentBlocState> emit,
  ) async {
    emit(AssignmentBlocState.loading(items: state.items));
    try {
      final items = await _repo.fetchAssignments(event.courseId);
      emit(AssignmentBlocState.idle(items: items));
    } catch (e) {
      emit(AssignmentBlocState.error(error: e.toString(), items: state.items));
    }
  }

  Future<void> _onCreate(
    CreateEvent event,
    Emitter<AssignmentBlocState> emit,
  ) async {
    emit(AssignmentBlocState.loading(items: state.items));
    try {
      await _repo.createAssignment(event.courseId, event.request);
      final items = await _repo.fetchAssignments(event.courseId);
      emit(AssignmentBlocState.idle(items: items));
    } catch (e) {
      emit(AssignmentBlocState.error(error: e.toString(), items: state.items));
    }
  }

  Future<void> _onEdit(
    EditEvent event,
    Emitter<AssignmentBlocState> emit,
  ) async {
    emit(AssignmentBlocState.loading(items: state.items));
    try {
      await _repo.editAssignment(event.assignmentId, event.request);
      final items = await _repo.fetchAssignments(event.courseId);
      emit(AssignmentBlocState.idle(items: items));
    } catch (e) {
      emit(AssignmentBlocState.error(error: e.toString(), items: state.items));
    }
  }

  Future<void> _onDelete(
    DeleteEvent event,
    Emitter<AssignmentBlocState> emit,
  ) async {
    emit(AssignmentBlocState.loading(items: state.items));
    try {
      await _repo.deleteAssignment(event.assignmentId);
      final items = await _repo.fetchAssignments(event.courseId);
      emit(AssignmentBlocState.idle(items: items));
    } catch (e) {
      emit(AssignmentBlocState.error(error: e.toString(), items: state.items));
    }
  }
}
