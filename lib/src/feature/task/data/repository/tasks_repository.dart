import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/i_tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_answers.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

class TasksRepository implements ITasksRepository {
  final ITasksDataSource _dataSource;
  final TokenStorage _tokenStorage;
  final IStorage<String> _orgIdStorage;

  TasksRepository({
    required ITasksDataSource dataSource,
    required TokenStorage tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _dataSource = dataSource,
        _tokenStorage = tokenStorage,
        _orgIdStorage = orgIdStorage;

  String get _token => _tokenStorage.load() ?? '';
  String get _orgId => _orgIdStorage.load() ?? '';

  @override
  Future<String> createTask({
    required String assignmentId,
    required TaskRequest task,
  }) =>
      _dataSource.createTask(
        organizationId: _orgId,
        token: _token,
        assignmentId: assignmentId,
        task: task,
      );

  @override
  Future<void> deleteTask(String taskId) => _dataSource.deleteTask(
        organizationId: _orgId,
        token: _token,
        taskId: taskId,
      );

  @override
  Future<void> addQuestionFile({
    required String taskId,
    required Uint8List file,
    required String fileName,
  }) =>
      _dataSource.addFileToTask(
        organizationId: _orgId,
        token: _token,
        taskId: taskId,
        fileBytes: file,
        filename: fileName,
      );

  @override
  Future<List<Task>> listTasks(String assignmentId) => _dataSource.getTasks(
        organizationId: _orgId,
        token: _token,
        assignmentId: assignmentId,
      );

  @override
  Future<String?> downloadQuestionFile(String taskId, String? name) async {
    final bytes = await _dataSource.downloadQuestionFile(
      organizationId: _orgId,
      token: _token,
      taskId: taskId,
    );
    final path = await FileSaver.instance.saveFile(
      name: '${taskId}_$name.pdf',
      bytes: bytes,
    );
    return path;
  }

  @override
  Future<void> answerText({
    required String assignmentId,
    required String taskId,
    required String text,
  }) =>
      _dataSource.answerText(
        organizationId: _orgId,
        token: _token,
        assignmentId: assignmentId,
        taskId: taskId,
        answer: text,
      );

  @override
  Future<void> answerFile({
    required String assignmentId,
    required String taskId,
    required Uint8List file,
    required String fileName,
  }) =>
      _dataSource.answerFile(
        organizationId: _orgId,
        token: _token,
        assignmentId: assignmentId,
        taskId: taskId,
        fileBytes: file,
        filename: fileName,
      );

  @override
  Future<void> evaluateTask({
    required String assignmentId,
    required String taskId,
    required String userId,
    required int score,
  }) =>
      _dataSource.evaluateTask(
        organizationId: _orgId,
        token: _token,
        assignmentId: assignmentId,
        taskId: taskId,
        userId: userId,
        evaluation: score,
      );

  @override
  Future<void> feedbackTask({
    required String assignmentId,
    required String taskId,
    required String userId,
    required String feedback,
  }) =>
      _dataSource.feedbackTask(
        organizationId: _orgId,
        token: _token,
        assignmentId: assignmentId,
        taskId: taskId,
        userId: userId,
        feedback: feedback,
      );

  @override
  Future<String?> downloadAnswerFile({
    required String assignmentId,
    required String taskId,
    required String userId,
    String? name,
  }) async {
    final bytes = await _dataSource.downloadAnswerFile(
      organizationId: _orgId,
      token: _token,
      assignmentId: assignmentId,
      taskId: taskId,
      userId: userId,
    );

    final path = await FileSaver.instance.saveFile(
      name: '${taskId}_$name.pdf',
      bytes: bytes,
    );
    return path;
  }

  @override
  Future<EvaluateAnswers> getStudentEvaluateAnswers(
    String assignmentId,
  ) =>
      _dataSource.fetchStudentEvaluateAnswers(
        organizationId: _orgId,
        token: _token,
        assignmentId: assignmentId,
      );
  @override
  Future<EvaluateAnswers> getTeacherEvaluateAnswers(
    String userId,
    String assignmentId,
  ) =>
      _dataSource.fetchTeacherEvaluateAnswers(
        organizationId: _orgId,
        token: _token,
        userId: userId,
        assignmentId: assignmentId,
      );
}
