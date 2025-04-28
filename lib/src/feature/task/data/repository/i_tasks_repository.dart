import 'dart:io';

import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

abstract interface class ITasksRepository {
  Future<List<Task>> listTasks(String assignmentId);

  Future<String> createTask(String assignmentId, TaskRequest req);

  Future<void> deleteTask(String taskId);

  Future<void> addQuestionFile(String taskId, File file);

  Future<void> answerText(String assignmentId, String taskId, String text);

  Future<void> answerFile(String assignmentId, String taskId, File file);

  Future<void> evaluateTask(
    String assignmentId,
    String taskId,
    String userId,
    int score,
  );

  Future<void> feedbackTask(
    String assignmentId,
    String taskId,
    String userId,
    String feedback,
  );
}
