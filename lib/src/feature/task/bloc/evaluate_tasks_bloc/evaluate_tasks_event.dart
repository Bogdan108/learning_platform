import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluate_tasks_event.freezed.dart';

@freezed
sealed class EvaluateTasksEvent with _$EvaluateTasksEvent {
  const factory EvaluateTasksEvent.teacherFetch({
    required String userId,
    required String assignmentId,
  }) = EvaluateTasksEvent$TeacherFetchEvaluateTasks;

  const factory EvaluateTasksEvent.studentFetch({
    required String assignmentId,
  }) = EvaluateTasksEvent$StudentFetchEvaluateTasks;

  const factory EvaluateTasksEvent.evaluate({
    required String taskId,
    required String assignmentId,
    required String userId,
    required int score,
    String? feedback,
  }) = EvaluateTasksEvent$EvaluateTask;
}
