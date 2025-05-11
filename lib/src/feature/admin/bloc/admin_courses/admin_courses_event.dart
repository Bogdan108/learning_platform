import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_courses_event.freezed.dart';

@freezed
sealed class AdminCoursesEvent with _$AdminCoursesEvent {
  const factory AdminCoursesEvent.fetchCourses({
    required String searchQuery,
  }) = AdminCoursesEvent$FetchCourses;

  const factory AdminCoursesEvent.editCourse({
    required String courseId,
    required String name,
    required String description,
  }) = AdminCoursesEvent$EditCourse;

  const factory AdminCoursesEvent.deleteCourse({
    required String courseId,
  }) = AdminCoursesEvent$DeleteCourse;
}
