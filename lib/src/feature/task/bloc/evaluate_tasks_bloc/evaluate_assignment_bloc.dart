import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_tasks_bloc/evaluate_tasks_event.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_tasks_bloc/evaluate_tasks_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';

class EvaluateTasksBloc extends Bloc<EvaluateTasksEvent, EvaluateTasksState> with SetStateMixin {
  final ITasksRepository _tasksRepository;

  EvaluateTasksBloc({required ITasksRepository tasksRepository})
      : _tasksRepository = tasksRepository,
        super(
          EvaluateTasksState.idle(
            evaluateAnswers: EvaluateAnswers.empty(),
          ),
        ) {
    on<EvaluateTasksEvent>(
      (event, emit) => switch (event) {
        EvaluateTasksEvent$FetchEvaluateTasks() => _onFetch(event, emit),
        EvaluateTasksEvent$EvaluateTask() => _onEvaluate(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    EvaluateTasksEvent$FetchEvaluateTasks event,
    Emitter<EvaluateTasksState> emit,
  ) async {
    emit(
      EvaluateTasksState.loading(
        evaluateAnswers: state.evaluateAnswers,
      ),
    );
    try {
      final list = await _tasksRepository.getEvaluateAnswers(
        event.answerId,
        event.assignmentId,
      );
      emit(EvaluateTasksState.idle(evaluateAnswers: list));
    } catch (err, st) {
      emit(
        EvaluateTasksState.error(
          message: err.toString(),
          evaluateAnswers: state.evaluateAnswers,
        ),
      );
      onError(err, st);
    }
  }

  Future<void> _onEvaluate(
    EvaluateTasksEvent$EvaluateTask event,
    Emitter<EvaluateTasksState> emit,
  ) async {
    emit(
      EvaluateTasksState.loading(
        evaluateAnswers: state.evaluateAnswers,
      ),
    );

    try {
      await _tasksRepository.evaluateTask(
        event.answerId,
        event.score,
      );

      if (event.feedback != null) {
        await _tasksRepository.feedbackTask(
          event.answerId,
          event.feedback!,
        );
      }
      // TODO(b.luckyanchuk): Add updating of the list after backend will be ready
      // final list = await _tasksRepository.getEvaluateAnswers(
      //   event.answerId,
      //   event.assignmentId,
      // );
      // emit(
      //   EvaluateAnswersBlocState.idle(evaluateAnswers: list),
      // );

      emit(
        EvaluateTasksState.idle(
          evaluateAnswers: state.evaluateAnswers,
        ),
      );
    } catch (err, st) {
      EvaluateTasksState.error(
        message: err.toString(),
        evaluateAnswers: state.evaluateAnswers,
      );

      onError(err, st);
    }
  }
}
