// lib/src/feature/answers/bloc/answers_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/answers_bloc/answers_bloc_event.dart';
import 'package:learning_platform/src/feature/task/bloc/answers_bloc/answers_bloc_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';

class AnswersBloc extends Bloc<AnswersBlocEvent, AnswersBlocState>
    with SetStateMixin {
  final ITasksRepository _repo;

  AnswersBloc({required ITasksRepository repo})
      : _repo = repo,
        super(const AnswersBlocState.idle(data: [])) {
    on<AnswersBlocEvent>(
      (event, emit) => switch (event) {
        FetchAnswersEvent() => _onFetch(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    FetchAnswersEvent e,
    Emitter<AnswersBlocState> emit,
  ) async {
    emit(AnswersBlocState.loading(data: state.data));

    try {
      final list = await _repo.getAnswersByCourse(e.courseId);
      emit(AnswersBlocState.idle(data: list));
    } catch (err, st) {
      emit(
        AnswersBlocState.error(
          error: 'Ошибка при загрузке ответов',
          data: state.data,
        ),
      );
      onError(err, st);
    }
  }
}
