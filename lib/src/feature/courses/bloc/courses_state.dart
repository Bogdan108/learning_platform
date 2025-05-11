import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';

part 'courses_state.freezed.dart';

@freezed
sealed class CoursesState with _$CoursesState {
  const factory CoursesState.idle({
    @Default([]) List<Course> courses,
  }) = CoursesState$Idle;

  const factory CoursesState.loading({
    @Default([]) List<Course> courses,
  }) = CoursesState$Loading;

  const factory CoursesState.error({
    required String error,
    @Default([]) List<Course> courses,
  }) = CoursesState$Error;
}
