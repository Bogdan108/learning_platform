import 'package:learning_platform/src/feature/course/model/course_additions.dart';

abstract class ICourseRepository {
  Future<CourseAdditions> getCourseAdditions(
    String organizationId,
    String courseId,
  );
  Future<void> deleteAddition(
    String organizationId,
    String courseId,
    String additionType,
    String additionId,
  );
  Future<void> addLinkAddition(
    String organizationId,
    String courseId,
    String link,
  );
}
