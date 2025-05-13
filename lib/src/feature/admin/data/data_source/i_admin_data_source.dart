import 'package:learning_platform/src/feature/admin/model/admin_user.dart';
import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';

abstract interface class IAdminDataSource {
  Future<List<AdminUser>> getUsers({
    required String organizationId,
    required String token,
    required String? searchQuery,
  });

  Future<void> changeUserRole({
    required String organizationId,
    required String token,
    required UserRoleRequest payload,
  });

  Future<void> deleteUser({
    required String organizationId,
    required String token,
    required String userId,
  });

  Future<List<Course>> getAllCourses({
    required String organizationId,
    required String token,
    required String? searchQuery,
  });

  Future<void> editCourse({
    required String organizationId,
    required String token,
    required String courseId,
    required CourseRequest course,
  });

  Future<void> deleteCourse({
    required String organizationId,
    required String token,
    required String courseId,
  });
}
