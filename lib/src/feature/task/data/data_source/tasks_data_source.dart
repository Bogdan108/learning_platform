// ignore_for_file: inference_failure_on_function_invocation

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/task/data/data_source/i_tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_task.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/model/task_request.dart';

class TasksDataSource implements ITasksDataSource {
  final Dio _dio;
  TasksDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<Task>> getTasks({
    required String organizationId,
    required String token,
    required String assignmentId,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/task/list',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'assignment_id': assignmentId,
      },
    );
    return response.data
            ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  @override
  Future<int> createTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required TaskRequest task,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/task/teacher',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'assignment_id': assignmentId,
      },
      data: task.toJson(),
    );
    final data = response.data;
    if (data != null && data.containsKey('task_id')) {
      return data['task_id'] as int;
    }
    throw Exception('Failed to create task');
  }

  @override
  Future<void> deleteTask({
    required String organizationId,
    required String token,
    required String taskId,
  }) =>
      _dio.delete(
        '/task/teacher',
        queryParameters: {
          'organization_id': organizationId,
          'token': token,
          'task_id': taskId,
        },
      );

  @override
  Future<void> addFileToTask({
    required String organizationId,
    required String token,
    required String taskId,
    required Uint8List fileBytes,
    required String filename,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: filename,
      ),
    });
    await _dio.post(
      '/task/teacher/add-file',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'task_id': taskId,
      },
      data: form,
    );
  }

  @override
  Future<Uint8List> downloadQuestionFile({
    required String organizationId,
    required String token,
    required String taskId,
  }) async {
    final resp = await _dio.get<Uint8List>(
      '/task/question/file',
      options: Options(responseType: ResponseType.bytes),
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'task_id': taskId,
      },
    );
    return resp.data ?? Uint8List.fromList([]);
  }

  @override
  Future<void> answerText({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String answer,
  }) =>
      _dio.post(
        '/task/student/answer/text',
        queryParameters: {
          'organization_id': organizationId,
          'token': token,
          'assignment_id': assignmentId,
          'task_id': taskId,
        },
        data: {'text': answer},
      );

  @override
  Future<void> answerFile({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required Uint8List fileBytes,
    required String filename,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: filename,
      ),
    });
    await _dio.post(
      '/task/student/answer/file',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'assignment_id': assignmentId,
        'task_id': taskId,
      },
      data: form,
    );
  }

  @override
  Future<void> evaluateTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
    required int evaluation,
  }) =>
      _dio.post(
        '/task/teacher/evaluate',
        queryParameters: {
          'organization_id': organizationId,
          'token': token,
          'assignment_id': assignmentId,
          'task_id': taskId,
          'user_id': userId,
        },
        data: {'assessment': evaluation},
      );

  @override
  Future<void> feedbackTask({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
    required String feedback,
  }) =>
      _dio.post(
        '/task/teacher/feedback',
        queryParameters: {
          'organization_id': organizationId,
          'token': token,
          'assignment_id': assignmentId,
          'task_id': taskId,
          'user_id': userId,
        },
        data: {'feedback': feedback},
      );

  @override
  Future<Uint8List> downloadAnswerFile({
    required String organizationId,
    required String token,
    required String assignmentId,
    required String taskId,
    required String userId,
  }) async {
    final resp = await _dio.get<Uint8List>(
      '/task/answer/file',
      options: Options(responseType: ResponseType.bytes),
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'task_id': taskId,
      },
    );
    return resp.data ?? Uint8List.fromList([]);
  }

  @override
  Future<List<EvaluateTask>> fetchStudentEvaluateAnswers({
    required String organizationId,
    required String token,
    required String assignmentId,
  }) async {
    final resp = await _dio.get(
      '/assignment/student/info',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'assignment_id': assignmentId,
      },
    );

    final list = resp.data as List<dynamic>?;
    return list
            ?.map((e) => EvaluateTask.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  @override
  Future<List<EvaluateTask>> fetchTeacherEvaluateAnswers({
    required String organizationId,
    required String token,
    required String userId,
    required String assignmentId,
  }) async {
    final resp = await _dio.get(
      '/assignment/teacher/info',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'assignment_id': assignmentId,
        'user_id': userId,
      },
    );

    final list = resp.data as List<dynamic>?;
    return list
            ?.map((e) => EvaluateTask.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }
}
