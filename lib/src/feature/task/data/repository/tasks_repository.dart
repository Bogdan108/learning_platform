import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

class TasksRepository implements ITasksRepository {
  final ITasksDataSource _tasksDataSource;
  final TokenStorage _tokenStorage;
  final IStorage<String> _orgId;

  TasksRepository({
    required ITasksDataSource dataSource,
    required TokenStorage tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _tasksDataSource = dataSource,
        _tokenStorage = tokenStorage,
        _orgId = orgIdStorage;

  String get _token => _tokenStorage.load() ?? '';
  String get _org => _orgId.load() ?? '';

  @override
  Future<List<Task>> listTasks(String assignmentId) => _tasksDataSource.listTasks(
        _org,
        _token,
        assignmentId,
      );

  @override
  Future<String> createTask(String assignmentId, TaskRequest req) =>
      _tasksDataSource.createTask(_org, _token, assignmentId, req);

  @override
  Future<void> deleteTask(String taskId) => _tasksDataSource.deleteTask(_org, _token, taskId);

  @override
  Future<String?> downloadQuestionFile(String taskId) async {
    final bytes = await _tasksDataSource.downloadQuestionFile(_org, _token, taskId);

    final path = await FileSaver.instance.saveFile(
      name: '$taskId.pdf',
      bytes: bytes,
    );
    return path;
  }

  @override
  Future<void> addQuestionFile(String taskId, File file) =>
      _tasksDataSource.addQuestionFile(_org, _token, taskId, file);

  @override
  Future<void> answerText(String assignmentId, String taskId, String text) =>
      _tasksDataSource.answerText(_org, _token, assignmentId, taskId, text);

  @override
  Future<void> answerFile(String assignmentId, String taskId, File file) =>
      _tasksDataSource.answerFile(_org, _token, assignmentId, taskId, file);

  @override
  Future<void> evaluateTask(
    String answerId,
    int score,
  ) =>
      _tasksDataSource.evaluateTask(_org, _token, answerId, score);

  @override
  Future<void> feedbackTask(
    String answerId,
    String fb,
  ) =>
      _tasksDataSource.feedbackTask(_org, _token, answerId, fb);

  @override
  Future<EvaluateAnswers> getStudentEvaluateAnswers(
    String assignmentId,
  ) =>
      _tasksDataSource.fetchStudentEvaluateAnswers(
        _org,
        _token,
        assignmentId,
      );
  @override
  Future<EvaluateAnswers> getTeacherEvaluateAnswers(
    String userId,
    String assignmentId,
  ) =>
      _tasksDataSource.fetchTeacherEvaluateAnswers(
        _org,
        _token,
        userId,
        assignmentId,
      );
}
