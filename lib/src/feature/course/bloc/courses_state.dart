import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/course/bloc/courses_event.dart';
import 'package:learning_platform/src/feature/course/model/course.dart';

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
    CoursesEvent? event,
  }) = CoursesState$Error;
}
