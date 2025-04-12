import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/courses/data/data_source/i_course_data_source.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_additions_response.dart';
import 'package:learning_platform/src/feature/courses/model/course_model.dart';

class CourseDataSource implements ICourseDataSource {
  final Dio _dio;

  CourseDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<String> createCourse(
    String organizationId,
    String token,
    CourseModel course,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/course/teacher',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
      },
      data: course.toJson(),
    );
    if (response.data != null && response.data!.containsKey('course_id')) {
      return response.data!['course_id'] as String;
    }
    throw Exception('Failed to create course');
  }

  @override
  Future<void> editCourse(
    String organizationId,
    String token,
    String courseId,
    CourseModel course,
  ) async {
    await _dio.put<Map<String, dynamic>>(
      '/course/teacher',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
      data: course.toJson(),
    );
  }

  @override
  Future<void> deleteCourse(
    String organizationId,
    String token,
    String courseId,
  ) async {
    await _dio.delete<Map<String, dynamic>>(
      '/course/teacher',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );
  }

  @override
  Future<List<Course>> getTeacherCourses(
    String organizationId,
    String token,
    String searchQuery,
  ) async {
    final response = await _dio.get<List<dynamic>>(
      '/course/teacher/list',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'search_query': searchQuery,
      },
    );

    return response.data!
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CourseAdditionsResponse> getCourseAdditions(
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

    return CourseAdditionsResponse.fromJson(response.data!);
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
  Future<void> enrollCourse(
    String organizationId,
    String token,
    String courseId,
  ) async {
    await _dio.post<Map<String, dynamic>>(
      '/course/student/add',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );
  }

  @override
  Future<List<Course>> getStudentCourses(
    String organizationId,
    String token,
    String searchQuery,
  ) async {
    final response = await _dio.get<List<dynamic>>(
      '/course/student/list',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'search_query': searchQuery,
      },
    );

    return response.data!
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
