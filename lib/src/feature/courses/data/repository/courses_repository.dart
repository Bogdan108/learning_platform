import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/courses/data/data_source/i_courses_data_source.dart';
import 'package:learning_platform/src/feature/courses/data/repository/i_courses_repository.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';

class CoursesRepository implements ICoursesRepository {
  final ICoursesDataSource dataSource;
  final TokenStorage tokenStorage;

  CoursesRepository({required this.dataSource, required this.tokenStorage});

  String get token => tokenStorage.load() ?? '';

  @override
  Future<String> createCourse(
    String organizationId,
    CourseRequest course,
  ) =>
      dataSource.createCourse(organizationId, token, course);

  @override
  Future<void> editCourse(
    String organizationId,
    String courseId,
    CourseRequest course,
  ) =>
      dataSource.editCourse(organizationId, token, courseId, course);

  @override
  Future<void> deleteCourse(
    String organizationId,
    String courseId,
  ) =>
      dataSource.deleteCourse(organizationId, token, courseId);

  @override
  Future<List<Course>> getTeacherCourses(
    String organizationId,
    String searchQuery,
  ) =>
      dataSource.getTeacherCourses(organizationId, token, searchQuery);

  @override
  Future<void> enrollCourse(
    String organizationId,
    String courseId,
  ) =>
      dataSource.enrollCourse(organizationId, token, courseId);

  @override
  Future<List<Course>> getStudentCourses(
    String organizationId,
    String searchQuery,
  ) =>
      dataSource.getStudentCourses(organizationId, token, searchQuery);
}
