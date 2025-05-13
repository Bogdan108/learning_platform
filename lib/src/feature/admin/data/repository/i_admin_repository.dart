import 'package:learning_platform/src/feature/admin/model/admin_user.dart';
import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';

abstract interface class IAdminRepository {
  Future<List<AdminUser>> getUsers(
    String? searchQuery,
  );

  Future<void> changeUserRole(
    UserRoleRequest payload,
  );

  Future<void> deleteUser(String userId);

  Future<List<Course>> getAllCourses(
    String? searchQuery,
  );

  Future<void> editCourse(
    String courseId,
    CourseRequest course,
  );

  Future<void> deleteCourse(
    String courseId,
  );
}
