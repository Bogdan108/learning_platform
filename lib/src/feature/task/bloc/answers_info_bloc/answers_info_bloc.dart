// lib/src/feature/answers/bloc/answers_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/answers_info_bloc/answers_info_bloc_event.dart';
import 'package:learning_platform/src/feature/task/bloc/answers_info_bloc/answers_info_bloc_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';

class AnswersInfoBloc extends Bloc<AnswersInfoBlocEvent, AnswersInfoBlocState>
    with SetStateMixin {
  final ITasksRepository _repo;

  AnswersInfoBloc({required ITasksRepository repo})
      : _repo = repo,
        super(const AnswersInfoBlocState.idle(data: [])) {
    on<AnswersInfoBlocEvent>(
      (event, emit) => switch (event) {
        FetchAnswersEvent() => _onFetch(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    FetchAnswersEvent e,
    Emitter<AnswersInfoBlocState> emit,
  ) async {
    emit(AnswersInfoBlocState.loading(data: state.data));

    try {
      final list = await _repo.getAnswersByCourse(e.courseId);
      emit(AnswersInfoBlocState.idle(data: list));
    } catch (err, st) {
      emit(
        AnswersInfoBlocState.error(
          error: 'Ошибка при загрузке ответов',
          data: state.data,
        ),
      );
      onError(err, st);
    }
  }
}
