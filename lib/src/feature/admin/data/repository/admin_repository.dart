import 'package:learning_platform/src/feature/admin/data/data_source/i_admin_data_source.dart';
import 'package:learning_platform/src/feature/admin/data/repository/i_admin_repository.dart';
import 'package:learning_platform/src/feature/admin/model/admin_user.dart';
import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';

class AdminRepository implements IAdminRepository {
  final IAdminDataSource _dataSource;
  final TokenStorage _tokenStorage;
  final IStorage<String> _orgIdStorage;

  AdminRepository({
    required IAdminDataSource dataSource,
    required TokenStorage tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _dataSource = dataSource,
        _tokenStorage = tokenStorage,
        _orgIdStorage = orgIdStorage;

  String get _token => _tokenStorage.load() ?? '';
  String get _orgId => _orgIdStorage.load() ?? '';

  @override
  Future<List<AdminUser>> getUsers(String searchQuery) => _dataSource.getUsers(
        organizationId: _orgId,
        token: _token,
        searchQuery: searchQuery,
      );

  @override
  Future<void> changeUserRole(UserRoleRequest payload) =>
      _dataSource.changeUserRole(
        organizationId: _orgId,
        token: _token,
        payload: payload,
      );

  @override
  Future<void> deleteUser(String userId) => _dataSource.deleteUser(
        organizationId: _orgId,
        token: _token,
        userId: userId,
      );

  @override
  Future<List<Course>> getAllCourses(String searchQuery) =>
      _dataSource.getAllCourses(
        organizationId: _orgId,
        token: _token,
        searchQuery: searchQuery,
      );

  @override
  Future<void> editCourse(String courseId, CourseRequest course) =>
      _dataSource.editCourse(
        organizationId: _orgId,
        token: _token,
        courseId: courseId,
        course: course,
      );

  @override
  Future<void> deleteCourse(String courseId) => _dataSource.deleteCourse(
        organizationId: _orgId,
        token: _token,
        courseId: courseId,
      );
}
