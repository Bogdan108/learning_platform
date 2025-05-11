import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluate_tasks_event.freezed.dart';

@freezed
sealed class EvaluateTasksEvent with _$EvaluateTasksEvent {
  const factory EvaluateTasksEvent.fetch({
    required String answerId,
    required String assignmentId,
  }) = EvaluateTasksEvent$FetchEvaluateTasks;

  const factory EvaluateTasksEvent.evaluate({
    required String answerId,
    required int score,
    String? feedback,
  }) = EvaluateTasksEvent$EvaluateTask;
}
