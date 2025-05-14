import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/courses/course/data/data_source/i_course_data_source.dart';
import 'package:learning_platform/src/feature/courses/course/data/repository/i_course_repository.dart';
import 'package:learning_platform/src/feature/courses/course/model/course_additions.dart';
import 'package:learning_platform/src/feature/courses/course/model/student.dart';

class CourseRepository implements ICourseRepository {
  final ICourseDataSource dataSource;
  final TokenStorage tokenStorage;
  final IStorage<String> orgIdStorage;

  CourseRepository({
    required this.dataSource,
    required this.tokenStorage,
    required this.orgIdStorage,
  });

  String get token => tokenStorage.load() ?? '';
  String get organizationId => orgIdStorage.load() ?? '';

  @override
  Future<CourseAdditions> getCourseAdditions(
    String courseId,
  ) =>
      dataSource.getCourseAdditions(organizationId, token, courseId);

  @override
  Future<void> deleteAddition(
    String courseId,
    String additionType,
    String additionId,
  ) =>
      dataSource.deleteAddition(
        organizationId,
        token,
        courseId,
        additionType,
        additionId,
      );

  @override
  Future<void> addLinkAddition(
    String courseId,
    String link,
  ) =>
      dataSource.addLinkAddition(organizationId, token, courseId, link);

  @override
  Future<List<Student>> getCourseStudents(
    String courseId,
  ) =>
      dataSource.getCourseStudents(organizationId, token, courseId);

  @override
  Future<String?> downloadMaterial(
    String courseId,
    String name,
    String additionId,
  ) async {
    final bytes = await dataSource.downloadMaterial(
      organizationId: organizationId,
      token: token,
      courseId: courseId,
      additionId: additionId,
    );

    final path = await FileSaver.instance.saveFile(
      name: '${courseId}_$name.pdf',
      bytes: bytes,
    );
    return path;
  }

  @override
  Future<void> uploadMaterial(
    String courseId,
    Uint8List file,
    String fileName,
  ) =>
      dataSource.uploadMaterial(
        organizationId: organizationId,
        token: token,
        courseId: courseId,
        file: file,
        fileName: fileName,
      );

  @override
  Future<void> leaveCourse(String courseId) => dataSource.leaveCourse(
        organizationId: organizationId,
        token: token,
        courseId: courseId,
      );
}
