import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/course/data/data_source/i_course_data_source.dart';
import 'package:learning_platform/src/feature/course/model/course_additions.dart';
import 'package:learning_platform/src/feature/course/model/student.dart';

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

    return response.data!.map(Student.fromJson).toList();
  }
}
