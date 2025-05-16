import 'dart:typed_data';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

abstract interface class ITasksRepository {
  Future<List<Task>> listTasks(
    String assignmentId,
  );

  Future<int> createTask({
    required String assignmentId,
    required TaskRequest task,
  });

  Future<void> deleteTask(
    String taskId,
  );

  Future<String?> downloadQuestionFile(
    String taskId,
    String? name,
  );

  Future<void> addQuestionFile({
    required String taskId,
    required Uint8List file,
    required String fileName,
  });

  Future<void> answerText({
    required String assignmentId,
    required String taskId,
    required String text,
  });

  Future<void> answerFile({
    required String assignmentId,
    required String taskId,
    required Uint8List file,
    required String fileName,
  });

  Future<void> evaluateTask({
    required String assignmentId,
    required String taskId,
    required String userId,
    required int score,
  });

  Future<void> feedbackTask({
    required String assignmentId,
    required String taskId,
    required String userId,
    required String feedback,
  });

  Future<String?> downloadAnswerFile({
    required String assignmentId,
    required String taskId,
    required String userId,
    String? name,
  });

  Future<EvaluateAnswers> getStudentEvaluateAnswers(
    String assignmentId,
  );

  Future<EvaluateAnswers> getTeacherEvaluateAnswers(
    String userId,
    String assignmentId,
  );
}
