import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/courses/model/course_request.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'courses_bloc_event.freezed.dart';

@freezed
sealed class CoursesBlocEvent with _$CoursesBlocEvent {
  /// Teacher
  const factory CoursesBlocEvent.createCourse({
    required CourseRequest course,
  }) = CreateCourseEvent;

  const factory CoursesBlocEvent.editCourse({
    required String courseId,
    required CourseRequest course,
  }) = EditCourseEvent;

  const factory CoursesBlocEvent.deleteCourse({
    required String courseId,
  }) = DeleteCourseEvent;

  const factory CoursesBlocEvent.fetchCourses({
    required UserRole role,
    required String searchQuery,
  }) = FetchCoursesEvent;

  /// Student
  const factory CoursesBlocEvent.enrollCourse({
    required String courseId,
  }) = EnrollCourseEvent;
}
