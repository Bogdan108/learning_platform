import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/assignment_answers.dart';
part 'assignment_answers_state.freezed.dart';

@freezed
sealed class AssignmentAnswersState with _$AssignmentAnswersState {
  const factory AssignmentAnswersState.idle({
    required List<AssignmentAnswers> data,
  }) = AssignmentAnswersState$Idle;

  const factory AssignmentAnswersState.loading({
    required List<AssignmentAnswers> data,
  }) = AssignmentAnswersState$Loading;

  const factory AssignmentAnswersState.error({
    required String error,
    required List<AssignmentAnswers> data,
  }) = AssignmentAnswersState$Error;
}
