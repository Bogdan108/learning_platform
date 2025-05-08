import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_assignment_bloc/evaluate_assignment_event.dart';
import 'package:learning_platform/src/feature/task/bloc/evaluate_assignment_bloc/evaluate_assignment_state.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';

class EvaluateAnswersBloc
    extends Bloc<EvaluateAssignmentEvent, EvaluateAssignmentState>
    with SetStateMixin {
  final ITasksRepository _tasksRepository;

  EvaluateAnswersBloc({required ITasksRepository tasksRepository})
      : _tasksRepository = tasksRepository,
        super(
          EvaluateAssignmentState.idle(
            evaluateAnswers: EvaluateAnswers.empty(),
          ),
        ) {
    on<EvaluateAssignmentEvent>(
      (event, emit) => switch (event) {
        EvaluateAssignmentEvent$FetchEvaluateTasks() => _onFetch(event, emit),
        EvaluateAssignmentEvent$EvaluateTask() => _onEvaluate(event, emit),
      },
    );
  }

  Future<void> _onFetch(
    EvaluateAssignmentEvent$FetchEvaluateTasks event,
    Emitter<EvaluateAssignmentState> emit,
  ) async {
    emit(
      EvaluateAssignmentState.loading(
        evaluateAnswers: state.evaluateAnswers,
      ),
    );
    try {
      final list = await _tasksRepository.getEvaluateAnswers(
        event.answerId,
        event.assignmentId,
      );
      emit(EvaluateAssignmentState.idle(evaluateAnswers: list));
    } catch (err, st) {
      emit(
        EvaluateAssignmentState.error(
          message: err.toString(),
          evaluateAnswers: state.evaluateAnswers,
        ),
      );
      onError(err, st);
    }
  }

  Future<void> _onEvaluate(
    EvaluateAssignmentEvent$EvaluateTask event,
    Emitter<EvaluateAssignmentState> emit,
  ) async {
    emit(
      EvaluateAssignmentState.loading(
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
        EvaluateAssignmentState.idle(
          evaluateAnswers: state.evaluateAnswers,
        ),
      );
    } catch (err, st) {
      EvaluateAssignmentState.error(
        message: err.toString(),
        evaluateAnswers: state.evaluateAnswers,
      );

      onError(err, st);
    }
  }
}
