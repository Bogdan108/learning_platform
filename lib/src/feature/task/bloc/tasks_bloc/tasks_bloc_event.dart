import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

part 'tasks_bloc_event.freezed.dart';

@freezed
sealed class TasksBlocEvent with _$TasksBlocEvent {
  const factory TasksBlocEvent.fetch(String assignmentId) = FetchTasks;

  const factory TasksBlocEvent.create({
    required String assignmentId,
    required TaskRequest req,
    required Uint8List? file,
    required String? name,
  }) = CreateTask;

  const factory TasksBlocEvent.delete(String taskId, String assignmentId) = DeleteTask;

  const factory TasksBlocEvent.addFile({
    required String taskId,
    required Uint8List file,
    required String name,
  }) = AddFileToTask;

  const factory TasksBlocEvent.answerText({
    required String assignmentId,
    required String taskId,
    required String text,
  }) = AnswerText;

  const factory TasksBlocEvent.answerFile({
    required String assignmentId,
    required String taskId,
    required Uint8List file,
    required String name,
  }) = AnswerFile;
}
