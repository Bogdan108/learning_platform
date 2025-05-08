import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/assignment_answers_bloc/assignment_answers_event.dart';
import 'package:learning_platform/src/feature/task/bloc/assignment_answers_bloc/assignment_answers_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';

class AssignmentAnswersBloc
    extends Bloc<AssignmentAnswersEvent, AssignmentAnswersState>
    with SetStateMixin {
  final ITasksRepository _repo;

  AssignmentAnswersBloc({required ITasksRepository repo})
      : _repo = repo,
        super(const AssignmentAnswersState.idle(data: [])) {
    on<AssignmentAnswersEvent>(
      (event, emit) => switch (event) {
        AssignmentAnswersEvent$FetchAnswers() => _onFetch(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    AssignmentAnswersEvent e,
    Emitter<AssignmentAnswersState> emit,
  ) async {
    emit(AssignmentAnswersState.loading(data: state.data));

    try {
      final list = await _repo.getAnswersByCourse(e.courseId);
      emit(AssignmentAnswersState.idle(data: list));
    } catch (err, st) {
      emit(
        AssignmentAnswersState.error(
          error: 'Ошибка при загрузке ответов',
          data: state.data,
        ),
      );
      onError(err, st);
    }
  }
}
