import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_event.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_state.dart';
import 'package:learning_platform/src/feature/assignment/data/repository/i_assignment_repository.dart';

class TeacherAssignmentAnswersBloc
    extends Bloc<TeacherAssignmentAnswersEvent, TeacherAssignmentAnswersState> with SetStateMixin {
  final IAssignmentRepository _assignmentRepository;

  TeacherAssignmentAnswersBloc({required IAssignmentRepository repository})
      : _assignmentRepository = repository,
        super(const TeacherAssignmentAnswersState.idle(data: [])) {
    on<TeacherAssignmentAnswersEvent>(
      (event, emit) => switch (event) {
        TeacherAssignmentAnswersEvent$FetchAnswers() => _onFetch(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    TeacherAssignmentAnswersEvent event,
    Emitter<TeacherAssignmentAnswersState> emit,
  ) async {
    emit(TeacherAssignmentAnswersState.loading(data: state.data));

    try {
      final list = await _assignmentRepository.getAnswersByCourse(event.courseId);
      emit(TeacherAssignmentAnswersState.idle(data: list));
    } catch (err, st) {
      emit(
        TeacherAssignmentAnswersState.error(
          error: 'Ошибка при загрузке ответов',
          data: state.data,
          event: event,
        ),
      );
      onError(err, st);
    }
  }
}
