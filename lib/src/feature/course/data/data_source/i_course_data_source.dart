import 'package:learning_platform/src/feature/course/model/course_additions.dart';

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
}
