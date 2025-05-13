// import 'package:dio/dio.dart';
// import 'package:learning_platform/src/feature/admin/data/data_source/i_admin_data_source.dart';
// import 'package:learning_platform/src/feature/admin/model/admin_user.dart';
// import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';
// import 'package:learning_platform/src/feature/courses/model/course.dart';
// import 'package:learning_platform/src/feature/courses/model/course_request.dart';

// class AdminDataSource implements IAdminDataSource {
//   final Dio _dio;
//   AdminDataSource({required Dio dio}) : _dio = dio;

//   @override
//   Future<List<AdminUser>> getUsers({
//     required String organizationId,
//     required String token,
//     required String? searchQuery,
//   }) async {
//     final response = await _dio.get<List<dynamic>>(
//       '/admin/user/list',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//          if(searchQuery != null)'search_query': searchQuery,
//       },
//     );
//     return response.data!
//         .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<void> changeUserRole({
//     required String organizationId,
//     required String token,
//     required UserRoleRequest payload,
//   }) async {
//     await _dio.put<void>(
//       '/admin/user/role',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//       },
//       data: payload.toJson(),
//     );
//   }

//   @override
//   Future<void> deleteUser({
//     required String organizationId,
//     required String token,
//     required String userId,
//   }) async {
//     await _dio.delete<void>(
//       '/admin/user',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'user_id': userId,
//       },
//     );
//   }

//   @override
//   Future<List<Course>> getAllCourses({
//     required String organizationId,
//     required String token,
//     required String? searchQuery,
//   }) async {
//     final response = await _dio.get<List<dynamic>>(
//       '/admin/course/list',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         if(searchQuery != null)'search_query': searchQuery,
//       },
//     );
//     return response.data!
//         .map((e) => Course.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<void> editCourse({
//     required String organizationId,
//     required String token,
//     required String courseId,
//     required CourseRequest course,
//   }) async {
//     await _dio.put<void>(
//       '/admin/course',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//       data: course.toJson(),
//     );
//   }

//   @override
//   Future<void> deleteCourse({
//     required String organizationId,
//     required String token,
//     required String courseId,
//   }) async {
//     await _dio.delete<void>(
//       '/admin/course',
//       queryParameters: {
//         'organization_id': organizationId,
//         'token': token,
//         'course_id': courseId,
//       },
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/admin/data/data_source/i_admin_data_source.dart';
import 'package:learning_platform/src/feature/admin/model/admin_user.dart';
import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class AdminDataSource implements IAdminDataSource {
  static const _delay = Duration(milliseconds: 500);

  final Dio _dio;
  const AdminDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<AdminUser>> getUsers({
    required String organizationId,
    required String token,
    required String? searchQuery,
  }) async =>
      Future.delayed(
        _delay,
        () => [
          const AdminUser(
            id: 'u1',
            fullName: UserName(
              firstName: 'Иван',
              secondName: 'Иванов',
              middleName: 'Иванович',
            ),
            email: 'ivan.ivanov@example.com',
            role: UserRole.student,
          ),
          const AdminUser(
            id: 'u2',
            fullName: UserName(
              firstName: 'Пётр',
              secondName: 'Петров',
              middleName: 'Петрович',
            ),
            email: 'petr.petrov@example.com',
            role: UserRole.teacher,
          ),
          const AdminUser(
            id: 'u3',
            fullName: UserName(
              firstName: 'Светлана',
              secondName: 'Седова',
              middleName: 'Александровна',
            ),
            email: 'svetlana@example.com',
            role: UserRole.admin,
          ),
        ],
      );

  @override
  Future<void> changeUserRole({
    required String organizationId,
    required String token,
    required UserRoleRequest payload,
  }) =>
      Future.delayed(_delay);

  @override
  Future<void> deleteUser({
    required String organizationId,
    required String token,
    required String userId,
  }) =>
      Future.delayed(_delay);

  @override
  Future<List<Course>> getAllCourses({
    required String organizationId,
    required String token,
    required String? searchQuery,
  }) async =>
      Future.delayed(
        _delay,
        () => const [
          Course(
            id: 'c1',
            name: 'Математика',
            description: 'Курс по алгебре и геометрии',
            isActive: true,
          ),
          Course(
            id: 'c2',
            name: 'Физика',
            description: 'Механика, электричество, оптика',
            isActive: false,
          ),
        ],
      );

  @override
  Future<void> editCourse({
    required String organizationId,
    required String token,
    required String courseId,
    required CourseRequest course,
  }) =>
      Future.delayed(_delay);

  @override
  Future<void> deleteCourse({
    required String organizationId,
    required String token,
    required String courseId,
  }) =>
      Future.delayed(_delay);
}
