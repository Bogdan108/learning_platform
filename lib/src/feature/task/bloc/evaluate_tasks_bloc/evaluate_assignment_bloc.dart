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
        EvaluateTasksEvent$TeacherFetchEvaluateTasks() => _onTeacherFetch(event, emit),
        EvaluateTasksEvent$StudentFetchEvaluateTasks() => _onStudentFetch(event, emit),
        EvaluateTasksEvent$EvaluateTask() => _onEvaluate(event, emit),
      },
    );
  }

  Future<void> _onTeacherFetch(
    EvaluateTasksEvent$TeacherFetchEvaluateTasks event,
    Emitter<EvaluateTasksState> emit,
  ) async {
    emit(
      EvaluateTasksState.loading(
        evaluateAnswers: state.evaluateAnswers,
      ),
    );
    try {
      final list = await _tasksRepository.getTeacherEvaluateAnswers(
        event.userId,
        event.assignmentId,
      );
      emit(EvaluateTasksState.idle(evaluateAnswers: list));
    } catch (err, st) {
      emit(
        EvaluateTasksState.error(
          message: 'Ошибка загрузки информации по задачам для учителя',
          evaluateAnswers: state.evaluateAnswers,
          event: event,
        ),
      );
      onError(err, st);
    }
  }

  Future<void> _onStudentFetch(
    EvaluateTasksEvent$StudentFetchEvaluateTasks event,
    Emitter<EvaluateTasksState> emit,
  ) async {
    emit(
      EvaluateTasksState.loading(
        evaluateAnswers: state.evaluateAnswers,
      ),
    );
    try {
      final list = await _tasksRepository.getStudentEvaluateAnswers(
        event.assignmentId,
      );
      emit(EvaluateTasksState.idle(evaluateAnswers: list));
    } catch (err, st) {
      emit(
        EvaluateTasksState.error(
          message: 'Ошибка загрузки информации по задачам для ученика',
          evaluateAnswers: state.evaluateAnswers,
          event: event,
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
        assignmentId: event.assignmentId,
        taskId: event.taskId,
        userId: event.userId,
        score: event.score,
      );

      if (event.feedback != null) {
        await _tasksRepository.feedbackTask(
          assignmentId: event.assignmentId,
          taskId: event.taskId,
          userId: event.userId,
          feedback: event.feedback!,
        );
      }
      final list = await _tasksRepository.getTeacherEvaluateAnswers(
        event.userId,
        event.assignmentId,
      );
      emit(
        EvaluateTasksState.idle(evaluateAnswers: list),
      );
    } catch (err, st) {
      emit(
        EvaluateTasksState.error(
          message: 'Ошибка оценки задания ${event.taskId}',
          evaluateAnswers: state.evaluateAnswers,
          event: event,
        ),
      );

      onError(err, st);
    }
  }
}
