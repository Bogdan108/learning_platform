import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_courses_bloc_event.freezed.dart';

@freezed
sealed class AdminCoursesBlocEvent with _$AdminCoursesBlocEvent {
  const factory AdminCoursesBlocEvent.fetchCourses({
    required String searchQuery,
  }) = FetchCoursesEvent;

  const factory AdminCoursesBlocEvent.editCourse({
    required String courseId,
    required String name,
    required String description,
  }) = EditCourseEvent;

  const factory AdminCoursesBlocEvent.deleteCourse({
    required String courseId,
  }) = DeleteCourseEvent;
}
