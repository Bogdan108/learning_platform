import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_courses/admin_courses_event.dart';
import 'package:learning_platform/src/feature/course/model/course.dart';

part 'admin_courses_state.freezed.dart';

@freezed
sealed class AdminCoursesState with _$AdminCoursesState {
  const factory AdminCoursesState.idle({
    @Default([]) List<Course> courses,
  }) = AdminCoursesState$Idle;

  const factory AdminCoursesState.loading({
    @Default([]) List<Course> courses,
  }) = AdminCoursesState$Loading;

  const factory AdminCoursesState.error({
    required String error,
    @Default([]) List<Course> courses,
    AdminCoursesEvent? event,
  }) = AdminCoursesState$Error;
}
