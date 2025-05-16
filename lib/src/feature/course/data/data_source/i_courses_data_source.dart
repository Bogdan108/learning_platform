import 'package:learning_platform/src/feature/course/model/course.dart';
import 'package:learning_platform/src/feature/course/model/course_request.dart';

abstract class ICoursesDataSource {
  Future<int> createCourse(
    String organizationId,
    String token,
    CourseRequest course,
  );

  Future<void> editCourse(
    String organizationId,
    String token,
    String courseId,
    CourseRequest course,
  );

  Future<void> deleteCourse(
    String organizationId,
    String token,
    String courseId,
  );

  Future<List<Course>> getTeacherCourses(
    String organizationId,
    String token,
    String? searchQuery,
  );

  Future<void> enrollCourse(
    String organizationId,
    String token,
    String courseId,
  );

  Future<List<Course>> getStudentCourses(
    String organizationId,
    String token,
    String? searchQuery,
  );
}
