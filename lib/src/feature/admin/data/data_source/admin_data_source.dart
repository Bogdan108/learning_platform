import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/admin/data/data_source/i_admin_data_source.dart';
import 'package:learning_platform/src/feature/admin/model/admin_user.dart';
import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';
import 'package:learning_platform/src/feature/course/model/course.dart';
import 'package:learning_platform/src/feature/course/model/course_request.dart';

class AdminDataSource implements IAdminDataSource {
  final Dio _dio;
  AdminDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<AdminUser>> getUsers({
    required String organizationId,
    required String token,
    required String? searchQuery,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/admin/user/list',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        if (searchQuery != null) 'search_query': searchQuery,
      },
    );
    return response.data!
        .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> changeUserRole({
    required String organizationId,
    required String token,
    required UserRoleRequest payload,
  }) async {
    await _dio.put<void>(
      '/admin/user/role',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
      },
      data: payload.toJson(),
    );
  }

  @override
  Future<void> deleteUser({
    required String organizationId,
    required String token,
    required String userId,
  }) async {
    await _dio.delete<void>(
      '/admin/user',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'user_id': userId,
      },
    );
  }

  @override
  Future<List<Course>> getAllCourses({
    required String organizationId,
    required String token,
    required String? searchQuery,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/admin/course/list',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        if (searchQuery != null) 'search_query': searchQuery,
      },
    );
    return response.data!
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> editCourse({
    required String organizationId,
    required String token,
    required String courseId,
    required CourseRequest course,
  }) async {
    await _dio.put<void>(
      '/admin/course',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
      data: course.toJson(),
    );
  }

  @override
  Future<void> deleteCourse({
    required String organizationId,
    required String token,
    required String courseId,
  }) async {
    await _dio.delete<void>(
      '/admin/course',
      queryParameters: {
        'organization_id': organizationId,
        'token': token,
        'course_id': courseId,
      },
    );
  }
}
