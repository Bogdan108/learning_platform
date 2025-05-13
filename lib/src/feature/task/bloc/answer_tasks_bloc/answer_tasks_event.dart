import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_tasks_event.freezed.dart';

@freezed
sealed class AnswerTasksEvent with _$AnswerTasksEvent {
  const factory AnswerTasksEvent.fetch({
    required String assignmentId,
    void Function()? onSuccess,
    void Function()? onError,
  }) = AnswerTasksEvent$FetchTasks;

  const factory AnswerTasksEvent.answerText({
    required String assignmentId,
    required String taskId,
    required String text,
    void Function()? onSuccess,
    void Function()? onError,
  }) = AnswerTasksEvent$AnswerText;

  const factory AnswerTasksEvent.answerFile({
    required String assignmentId,
    required String taskId,
    required Uint8List file,
    required String fileName,
    void Function()? onSuccess,
    void Function()? onError,
  }) = AnswerTasksEvent$AnswerFile;
}
