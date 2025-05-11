import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'courses_bloc_event.freezed.dart';

@freezed
sealed class CoursesBlocEvent with _$CoursesBlocEvent {
  const factory CoursesBlocEvent.fetchCourses({
    required UserRole role,
    required String searchQuery,
  }) = FetchCoursesEvent;

  /// Teacher
  const factory CoursesBlocEvent.createCourse({
    required String name,
    required String description,
  }) = CreateCourseEvent;

  const factory CoursesBlocEvent.editCourse({
    required String courseId,
    required String name,
    required String description,
  }) = EditCourseEvent;

  const factory CoursesBlocEvent.deleteCourse({
    required String courseId,
  }) = DeleteCourseEvent;

  /// Student
  const factory CoursesBlocEvent.enrollCourse({
    required String courseId,
  }) = EnrollCourseEvent;
}
