import 'dart:io';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';
import 'package:path_provider/path_provider.dart';

class TasksRepository implements ITasksRepository {
  final ITasksDataSource _ds;
  final TokenStorage _tok;
  final IStorage<String> _orgId;

  TasksRepository({
    required ITasksDataSource dataSource,
    required TokenStorage tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _ds = dataSource,
        _tok = tokenStorage,
        _orgId = orgIdStorage;

  String get _tokS => _tok.load() ?? '';
  String get _org => _orgId.load() ?? '';

  @override
  Future<List<Task>> listTasks(String assignmentId) => _ds.listTasks(
        _org,
        _tokS,
        assignmentId,
      );

  @override
  Future<String> createTask(String assignmentId, TaskRequest req) =>
      _ds.createTask(_org, _tokS, assignmentId, req);

  @override
  Future<void> deleteTask(String taskId) => _ds.deleteTask(_org, _tokS, taskId);

  @override
  Future<String> downloadQuestionFile(String taskId) async {
    final bytes = await _ds.downloadQuestionFile(_org, _tokS, taskId);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$taskId.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  @override
  Future<void> addQuestionFile(String taskId, File file) =>
      _ds.addQuestionFile(_org, _tokS, taskId, file);

  @override
  Future<void> answerText(String assignmentId, String taskId, String text) =>
      _ds.answerText(_org, _tokS, assignmentId, taskId, text);

  @override
  Future<void> answerFile(String assignmentId, String taskId, File file) =>
      _ds.answerFile(_org, _tokS, assignmentId, taskId, file);

  @override
  Future<void> evaluateTask(
    String answerId,
    int score,
  ) =>
      _ds.evaluateTask(_org, _tokS, answerId, score);

  @override
  Future<void> feedbackTask(
    String answerId,
    String fb,
  ) =>
      _ds.feedbackTask(_org, _tokS, answerId, fb);

  @override
  Future<List<AssignmentAnswers>> getAnswersByCourse(String courseId) => _ds.fetchAnswers(
        _org,
        _tokS,
        courseId,
      );

  @override
  Future<EvaluateAnswers> getEvaluateAnswers(
    String courseId,
    String assignmentId,
  ) =>
      _ds.fetchEvaluateAnswers(
        _org,
        _tokS,
        courseId,
        assignmentId,
      );
}
