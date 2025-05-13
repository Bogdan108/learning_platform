import 'dart:typed_data';
import 'package:learning_platform/src/feature/course/model/course_additions.dart';
import 'package:learning_platform/src/feature/course/model/student.dart';

abstract class ICourseDataSource {
  Future<CourseAdditions> getCourseAdditions(
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

  Future<Uint8List> downloadMaterial({
    required String organizationId,
    required String token,
    required String courseId,
    required String additionId,
  });

  Future<List<Student>> getCourseStudents(
    String organizationId,
    String token,
    String courseId,
  );

  Future<void> uploadMaterial({
    required String organizationId,
    required String token,
    required String courseId,
    required Uint8List file,
    required String fileName,
  });

  Future<void> leaveCourse({
    required String organizationId,
    required String token,
    required String courseId,
  });
}
