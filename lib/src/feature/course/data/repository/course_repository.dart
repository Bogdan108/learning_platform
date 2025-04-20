import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/course/data/data_source/i_course_data_source.dart';
import 'package:learning_platform/src/feature/course/data/repository/i_course_repository.dart';
import 'package:learning_platform/src/feature/course/model/course_additions.dart';

class CourseRepository implements ICourseRepository {
  final ICourseDataSource dataSource;
  final TokenStorage tokenStorage;

  CourseRepository({required this.dataSource, required this.tokenStorage});

  String get token => tokenStorage.load() ?? '';

  @override
  Future<CourseAdditions> getCourseAdditions(
    String organizationId,
    String courseId,
  ) =>
      dataSource.getCourseAdditions(organizationId, token, courseId);

  @override
  Future<void> deleteAddition(
    String organizationId,
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
    String organizationId,
    String courseId,
    String link,
  ) =>
      dataSource.addLinkAddition(organizationId, token, courseId, link);
}
