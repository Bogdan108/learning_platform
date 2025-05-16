import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_state.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/i_assignment_repository.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final IAssignmentRepository _repo;

  AssignmentBloc({required IAssignmentRepository repo})
      : _repo = repo,
        super(const AssignmentState.idle(items: [])) {
    on<AssignmentEvent>(
      (event, emit) => switch (event) {
        AssignmentEvent$Fetch() => _onFetch(event, emit),
        AssignmentEvent$Create() => _onCreate(event, emit),
        AssignmentEvent$Edit() => _onEdit(event, emit),
        AssignmentEvent$Delete() => _onDelete(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    AssignmentEvent$Fetch event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentState.loading(items: state.items));
    try {
      final items = await _repo.fetchCourseAssignments(event.courseId);
      emit(AssignmentState.idle(items: items));
    } catch (e) {
      log(e.toString());
      emit(
        AssignmentState.error(
          error: 'Ошибка загрузки заданий',
          items: state.items,
          event: event,
        ),
      );
    }
  }

  Future<void> _onCreate(
    AssignmentEvent$Create event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentState.loading(items: state.items));
    try {
      await _repo.createAssignment(event.courseId, event.request);
      final items = await _repo.fetchCourseAssignments(event.courseId);
      emit(AssignmentState.idle(items: items));
    } catch (e) {
      log('Error is $e');
      emit(
        AssignmentState.error(
          error: 'Ошибка создания задания',
          items: state.items,
          event: event,
        ),
      );
    }
  }

  Future<void> _onEdit(
    AssignmentEvent$Edit event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentState.loading(items: state.items));
    try {
      await _repo.editAssignment(event.assignmentId, event.request);
      final items = await _repo.fetchCourseAssignments(event.courseId);
      emit(AssignmentState.idle(items: items));
    } catch (e) {
      emit(
        AssignmentState.error(
          error: 'Ошибка изменения задания',
          items: state.items,
          event: event,
        ),
      );
    }
  }

  Future<void> _onDelete(
    AssignmentEvent$Delete event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentState.loading(items: state.items));
    try {
      await _repo.deleteAssignment(event.assignmentId);
      final items = await _repo.fetchCourseAssignments(event.courseId);
      emit(AssignmentState.idle(items: items));
    } catch (e) {
      emit(
        AssignmentState.error(
          error: 'Ошибка удаления задания',
          items: state.items,
          event: event,
        ),
      );
    }
  }
}
