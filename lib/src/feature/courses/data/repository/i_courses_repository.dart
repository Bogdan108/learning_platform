import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';

abstract class ICoursesRepository {
  Future<String> createCourse(
    String organizationId,
    CourseRequest course,
  );
  Future<void> editCourse(
    String organizationId,
    String courseId,
    CourseRequest course,
  );
  Future<void> deleteCourse(
    String organizationId,
    String courseId,
  );
  Future<List<Course>> getTeacherCourses(
    String organizationId,
    String searchQuery,
  );

  Future<void> enrollCourse(
    String organizationId,
    String courseId,
  );
  Future<List<Course>> getStudentCourses(
    String organizationId,
    String searchQuery,
  );
}
