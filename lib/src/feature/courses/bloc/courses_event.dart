import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'courses_event.freezed.dart';

@freezed
sealed class CoursesEvent with _$CoursesEvent {
  const factory CoursesEvent.fetchCourses({
    required UserRole role,
    String? searchQuery,
  }) = CoursesEvent$FetchCourses;

  /// Teacher
  const factory CoursesEvent.createCourse({
    required String name,
    required String description,
  }) = CoursesEvent$CreateCourse;

  const factory CoursesEvent.editCourse({
    required String courseId,
    required String name,
    required String description,
  }) = CoursesEvent$EditCourse;

  const factory CoursesEvent.deleteCourse({
    required String courseId,
  }) = CoursesEvent$DeleteCourse;

  /// Student
  const factory CoursesEvent.enrollCourse({
    required String courseId,
  }) = CoursesEvent$EnrollCourse;
}
