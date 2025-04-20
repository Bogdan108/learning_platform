import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/courses/data/data_source/i_courses_data_source.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';

class CoursesDataSource implements ICoursesDataSource {
  final Dio _dio;

  CoursesDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<String> createCourse(
    String organizationId,
    String token,
    CourseRequest course,
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
    CourseRequest course,
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
