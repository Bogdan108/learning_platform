import 'package:learning_platform/src/feature/courses/model/course.dart';
import 'package:learning_platform/src/feature/courses/model/course_additions_response.dart';
import 'package:learning_platform/src/feature/courses/model/course_model.dart';

abstract class ICourseDataSource {
  Future<String> createCourse(
    String organizationId,
    String token,
    CourseModel course,
  );
  Future<void> editCourse(
    String organizationId,
    String token,
    String courseId,
    CourseModel course,
  );
  Future<void> deleteCourse(
    String organizationId,
    String token,
    String courseId,
  );
  Future<List<Course>> getTeacherCourses(
    String organizationId,
    String token,
    String searchQuery,
  );
  Future<CourseAdditionsResponse> getCourseAdditions(
    String organizationId,
    String token,
    String courseId,
  );
  Future<void> deleteAddition(
    String organizationId,
    String token,
    String courseId,
    String additionType,
    String additionId,
  );
  Future<void> addLinkAddition(
    String organizationId,
    String token,
    String courseId,
    String link,
  );
  Future<void> enrollCourse(
    String organizationId,
    String token,
    String courseId,
  );
  Future<List<Course>> getStudentCourses(
    String organizationId,
    String token,
    String searchQuery,
  );
}
