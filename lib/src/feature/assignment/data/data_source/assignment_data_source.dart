import 'dart:async';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/assignment/data/data_source/i_assignment_data_source.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_request.dart';

class AssignmentDataSource implements IAssignmentDataSource {
  final Dio _dio;
  AssignmentDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<Assignment>> getCourseAssignments(
    String organizationId,
    String token,
    String courseId,
  ) async {
    final response = await _dio.get(
      '/assignment/list',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );

    final rawList = response.data as List<dynamic>?;

    final assignments = rawList
            ?.map((e) => Assignment.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return assignments;
  }

  @override
  Future<int> createAssignment(
    String organizationId,
    String token,
    String courseId,
    AssignmentRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/assignment/teacher',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
      data: request.toJson(),
    );

    if (response.data != null && response.data!.containsKey('assignment_id')) {
      return response.data!['assignment_id'] as int;
    }
    throw Exception('Failed to create assignment');
  }

  @override
  Future<void> editAssignment(
    String organizationId,
    String token,
    String assignmentId,
    AssignmentRequest request,
  ) async {
    await _dio.put<void>(
      '/assignment/teacher',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'assignment_id': assignmentId,
      },
      data: request.toJson(),
    );
  }

  @override
  Future<void> deleteAssignment(
    String organizationId,
    String token,
    String assignmentId,
  ) async {
    await _dio.delete<void>(
      '/assignment/teacher',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'assignment_id': assignmentId,
      },
    );
  }

  @override
  Future<List<AssignmentAnswers>> fetchAssignmentAnswers(
      String organizationId, String token, String courseId) async {
    final response = await _dio.get<List<dynamic>>(
      '/course/assignments/answers',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );

    return response.data
            ?.map((item) =>
                AssignmentAnswers.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];
  }

  @override
  Future<List<AssignmentCourses>> getAssignments(
      String organizationId, String token) async {
    final response = await _dio.get<List<dynamic>>(
      '/assignment/courses',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
      },
    );

    return response.data
            ?.map((e) => AssignmentCourses.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }
}
