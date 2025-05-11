import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';

part 'evaluate_tasks_state.freezed.dart';

@freezed
sealed class EvaluateTasksState with _$EvaluateTasksState {
  const factory EvaluateTasksState.idle({
    required EvaluateAnswers evaluateAnswers,
  }) = EvaluateTasksState$Idle;

  const factory EvaluateTasksState.loading({
    required EvaluateAnswers evaluateAnswers,
  }) = EvaluateTasksState$Loading;

  const factory EvaluateTasksState.error({
    required String message,
    required EvaluateAnswers evaluateAnswers,
  }) = EvaluateTasksState$Error;
}
