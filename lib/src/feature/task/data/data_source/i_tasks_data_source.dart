import 'package:flutter/services.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_task.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

abstract class ITasksDataSource {
  Future<int> createTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required TaskRequest task,
  });

  Future<void> deleteTask({
    required String organizationId,
    required String token,
    required String taskId,
  });

  Future<void> addFileToTask({
    required String organizationId,
    required String token,
    required String taskId,
    required Uint8List fileBytes,
    required String filename,
  });

  Future<List<Task>> getTasks({
    required String organizationId,
    required String token,
    required String assignmentId,
  });

  Future<Uint8List> downloadQuestionFile({
    required String organizationId,
    required String token,
    required String taskId,
  });

  Future<void> answerText({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String answer,
  });

  Future<void> answerFile({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required Uint8List fileBytes,
    required String filename,
  });

  Future<void> evaluateTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
    required int evaluation,
  });

  Future<void> feedbackTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
    required String feedback,
  });

  Future<Uint8List> downloadAnswerFile({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
  });

  Future<List<EvaluateTask>> fetchStudentEvaluateAnswers({
    required String organizationId,
    required String token,
    required String assignmentId,
  });

  Future<List<EvaluateTask>> fetchTeacherEvaluateAnswers({
    required String organizationId,
    required String token,
    required String userId,
    required String assignmentId,
  });
}
