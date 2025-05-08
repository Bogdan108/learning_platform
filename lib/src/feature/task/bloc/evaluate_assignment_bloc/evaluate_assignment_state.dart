import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';

part 'evaluate_assignment_state.freezed.dart';

@freezed
sealed class EvaluateAssignmentState with _$EvaluateAssignmentState {
  const factory EvaluateAssignmentState.idle({
    required EvaluateAnswers evaluateAnswers,
  }) = EvaluateAssignmentState$Idle;

  const factory EvaluateAssignmentState.loading({
    required EvaluateAnswers evaluateAnswers,
  }) = EvaluateAssignmentState$Loading;

  const factory EvaluateAssignmentState.error({
    required String message,
    required EvaluateAnswers evaluateAnswers,
  }) = EvaluateAssignmentState$Error;
}
