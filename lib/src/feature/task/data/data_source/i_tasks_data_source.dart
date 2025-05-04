import 'dart:io';

import 'package:flutter/services.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

abstract interface class ITasksDataSource {
  Future<List<Task>> listTasks(String org, String tok, String assignmentId);

  Future<String> createTask(
    String org,
    String tok,
    String assignmentId,
    TaskRequest req,
  );

  Future<void> deleteTask(String org, String tok, String taskId);

  Future<void> addQuestionFile(
    String org,
    String tok,
    String taskId,
    File file,
  );

  Future<Uint8List> downloadQuestionFile(String org, String tok, String taskId);

  Future<void> answerText(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String text,
  );

  Future<void> answerFile(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    File file,
  );

  Future<void> evaluateTask(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String userId,
    int score,
  );

  Future<void> feedbackTask(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String userId,
    String feedback,
  );
}
