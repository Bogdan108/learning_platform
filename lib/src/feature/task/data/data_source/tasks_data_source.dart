import 'dart:io';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

class TasksDataSource implements ITasksDataSource {
  final Dio _dio;
  TasksDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<Task>> listTasks(
    String org,
    String tok,
    String assignmentId,
  ) async {
    final resp = await _dio.get<List<dynamic>>(
      '/task/list',
      queryParameters: {
        'organization_id': org,
        'token': tok,
        'assignment_id': assignmentId,
      },
    );
    return resp.data!
        .map((j) => Task.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<String> createTask(
    String org,
    String tok,
    String assignmentId,
    TaskRequest req,
  ) async {
    final resp = await _dio.post<Map<String, dynamic>>(
      '/task/teacher',
      queryParameters: {
        'organization_id': org,
        'token': tok,
        'assignment_id': assignmentId,
      },
      data: req.toJson(),
    );
    return resp.data!['task_id'] as String;
  }

  @override
  Future<void> deleteTask(String org, String tok, String taskId) =>
      _dio.delete<void>(
        '/task/teacher',
        queryParameters: {
          'organization_id': org,
          'token': tok,
          'task_id': taskId,
        },
      );

  @override
  Future<void> addQuestionFile(
    String org,
    String tok,
    String taskId,
    File file,
  ) =>
      _dio.post<void>(
        '/task/teacher/add-file',
        queryParameters: {
          'organization_id': org,
          'token': tok,
          'task_id': taskId,
        },
        data: FormData.fromMap({
          'file': MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
          ),
        }),
      );

  // @override
  // Future<File> downloadQuestionFile(
  //   String org,
  //   String tok,
  //   String taskId,
  // ) async {
  //   final resp = await _dio.get<Uint8List>(
  //     '/task/question/file',
  //     queryParameters: {
  //       'organization_id': org,
  //       'token': tok,
  //       'task_id': taskId,
  //     },
  //     options: Options(responseType: ResponseType.bytes),
  //   );
  //   //
  // }

  @override
  Future<void> answerText(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String text,
  ) =>
      _dio.post<void>(
        '/task/student/answer/text',
        queryParameters: {
          'organization_id': org,
          'token': tok,
          'assignment_id': assignmentId,
          'task_id': taskId,
        },
        data: {'text': text},
      );

  @override
  Future<void> answerFile(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    File file,
  ) =>
      _dio.post<void>(
        '/task/student/answer/file',
        queryParameters: {
          'organization_id': org,
          'token': tok,
          'assignment_id': assignmentId,
          'task_id': taskId,
        },
        data: FormData.fromMap({
          'file': MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
          ),
        }),
      );

  @override
  Future<void> evaluateTask(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String userId,
    int score,
  ) =>
      _dio.post<void>(
        '/task/teacher/evaluate',
        queryParameters: {
          'organization_id': org,
          'token': tok,
          'assignment_id': assignmentId,
          'task_id': taskId,
          'user_id': userId,
        },
        data: {'assessment': score},
      );

  @override
  Future<void> feedbackTask(
    String org,
    String tok,
    String assignmentId,
    String taskId,
    String userId,
    String feedback,
  ) =>
      _dio.post<void>(
        '/task/teacher/feedback',
        queryParameters: {
          'organization_id': org,
          'token': tok,
          'assignment_id': assignmentId,
          'task_id': taskId,
          'user_id': userId,
        },
        data: {'feedback': feedback},
      );
}
