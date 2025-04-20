import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'courses_bloc_event.freezed.dart';

@freezed
sealed class CoursesBlocEvent with _$CoursesBlocEvent {
  /// Teacher
  const factory CoursesBlocEvent.createCourse({
    required String organizationId,
    required String token,
    required CourseRequest course,
  }) = CreateCourseEvent;

  const factory CoursesBlocEvent.editCourse({
    required String organizationId,
    required String token,
    required String courseId,
    required CourseRequest course,
  }) = EditCourseEvent;

  const factory CoursesBlocEvent.deleteCourse({
    required String organizationId,
    required String token,
    required String courseId,
  }) = DeleteCourseEvent;

  const factory CoursesBlocEvent.fetchCourses({
    required String organizationId,
    required String token,
    required UserRole role,
    required String searchQuery,
  }) = FetchCoursesEvent;

  /// Student
  const factory CoursesBlocEvent.enrollCourse({
    required String organizationId,
    required String token,
    required String courseId,
  }) = EnrollCourseEvent;
}
