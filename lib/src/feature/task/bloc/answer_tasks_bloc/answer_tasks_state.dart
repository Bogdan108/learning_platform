import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/bloc/answer_tasks_bloc/answer_tasks_event.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';

part 'answer_tasks_state.freezed.dart';

@freezed
sealed class AnswerTasksState with _$AnswerTasksState {
  const factory AnswerTasksState.idle({
    required List<Task> tasks,
    AnswerTasksEvent? event,
  }) = AnswerTasksState$Idle;

  const factory AnswerTasksState.loading({
    required List<Task> tasks,
    AnswerTasksEvent? event,
  }) = AnswerTasksState$Loading;

  const factory AnswerTasksState.error({
    required String error,
    required List<Task> tasks,
    AnswerTasksEvent? event,
  }) = AnswerTasksState$Error;
}
