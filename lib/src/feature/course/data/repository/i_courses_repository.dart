import 'package:learning_platform/src/feature/course/model/course.dart';
import 'package:learning_platform/src/feature/course/model/course_request.dart';

abstract class ICoursesRepository {
  Future<int> createCourse(
    CourseRequest course,
  );

  Future<void> editCourse(
    String courseId,
    CourseRequest course,
  );

  Future<void> deleteCourse(
    String courseId,
  );

  Future<List<Course>> getTeacherCourses(
    String? searchQuery,
  );

  Future<void> enrollCourse(
    String courseId,
  );

  Future<List<Course>> getStudentCourses(
    String? searchQuery,
  );
}
