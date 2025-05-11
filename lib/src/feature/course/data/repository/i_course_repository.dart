import 'dart:io';
import 'package:learning_platform/src/feature/course/model/course_additions.dart';
import 'package:learning_platform/src/feature/course/model/student.dart';

abstract class ICourseRepository {
  Future<CourseAdditions> getCourseAdditions(
    String courseId,
  );

  Future<void> deleteAddition(
    String courseId,
    String additionType,
    String additionId,
  );

  Future<void> addLinkAddition(
    String courseId,
    String link,
  );

  Future<List<Student>> getCourseStudents(
    String courseId,
  );

  Future<String> downloadMaterial(
    String courseId,
    String name,
    String additionId,
  );

  Future<void> uploadMaterial(String courseId, File file);

  Future<void> leaveCourse(String courseId);
}
