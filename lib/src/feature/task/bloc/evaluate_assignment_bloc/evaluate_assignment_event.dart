import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluate_assignment_event.freezed.dart';

@freezed
sealed class EvaluateAssignmentEvent with _$EvaluateAssignmentEvent {
  const factory EvaluateAssignmentEvent.fetch({
    required String answerId,
    required String assignmentId,
  }) = EvaluateAssignmentEvent$FetchEvaluateTasks;

  const factory EvaluateAssignmentEvent.evaluate({
    required String answerId,
    required int score,
    String? feedback,
  }) = EvaluateAssignmentEvent$EvaluateTask;
}
