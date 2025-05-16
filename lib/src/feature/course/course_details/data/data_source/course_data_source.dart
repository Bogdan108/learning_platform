import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/course/course_details/data/data_source/i_course_data_source.dart';
import 'package:learning_platform/src/feature/course/course_details/model/course_additions.dart';
import 'package:learning_platform/src/feature/course/course_details/model/student.dart';

class CourseDataSource implements ICourseDataSource {
  final Dio _dio;

  CourseDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<CourseAdditions> getCourseAdditions(
    String organizationId,
    String token,
    String courseId,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/course/additions',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );

    return CourseAdditions.fromJson(response.data!);
  }

  @override
  Future<void> deleteAddition(
    String organizationId,
    String token,
    String courseId,
    String additionType,
    String additionId,
  ) async {
    await _dio.delete<Map<String, dynamic>>(
      '/course/additions',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
        'addition_type': additionType,
        'addition_id': additionId,
      },
    );
  }

  @override
  Future<void> addLinkAddition(
    String organizationId,
    String token,
    String courseId,
    String link,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/course/teacher/additions/link',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
      data: {link: link},
    );
  }

  @override
  Future<Uint8List> downloadMaterial({
    required String organizationId,
    required String token,
    required String courseId,
    required String additionId,
  }) async {
    final response = await _dio.get<Uint8List>(
      '/course/additions/material',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
        'addition_id': additionId,
      },
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    return response.data ?? Uint8List.fromList([]);
  }

  @override
  Future<List<Student>> getCourseStudents(
    String organizationId,
    String token,
    String courseId,
  ) async {
    final response = await _dio.get<List<Map<String, dynamic>>>(
      '/course/teacher/student-list',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );

    return response.data?.map(Student.fromJson).toList() ?? [];
  }

  @override
  Future<void> uploadMaterial({
    required String organizationId,
    required String token,
    required String courseId,
    required Uint8List file,
    required String fileName,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file,
        filename: fileName,
      ),
    });

    await _dio.post<void>(
      '/course/teacher/additions/material',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
      data: form,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  @override
  Future<void> leaveCourse({
    required String organizationId,
    required String token,
    required String courseId,
  }) async {
    await _dio.post<void>(
      '/course/student/leave',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );
  }
}
