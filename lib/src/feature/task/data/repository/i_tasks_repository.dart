import 'dart:io';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

abstract interface class ITasksRepository {
  Future<List<Task>> listTasks(String assignmentId);

  Future<String> createTask(String assignmentId, TaskRequest req);

  Future<void> deleteTask(String taskId);

  Future<String> downloadQuestionFile(String taskId);

  Future<void> addQuestionFile(String taskId, File file);

  Future<void> answerText(String assignmentId, String taskId, String text);

  Future<void> answerFile(String assignmentId, String taskId, File file);

  Future<void> evaluateTask(
    String answerId,
    int score,
  );

  Future<void> feedbackTask(
    String answerId,
    String feedback,
  );

  Future<EvaluateAnswers> getEvaluateAnswers(
    String answerId,
    String assignmentId,
  );
}
