import 'dart:typed_data';
import 'package:learning_platform/src/feature/course/course_details/model/course_additions.dart';
import 'package:learning_platform/src/feature/course/course_details/model/student.dart';

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

  Future<String?> downloadMaterial(
    String courseId,
    String name,
    String additionId,
  );

  Future<void> uploadMaterial(
    String courseId,
    Uint8List file,
    String fileName,
  );

  Future<void> leaveCourse(String courseId);
}
