import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';

part 'courses_bloc_state.freezed.dart';

@freezed
sealed class CoursesBlocState with _$CoursesBlocState {
  const factory CoursesBlocState.idle({
    @Default([]) List<Course> courses,
  }) = Idle;

  const factory CoursesBlocState.loading({
    @Default([]) List<Course> courses,
  }) = Loading;

  const factory CoursesBlocState.error({
    required String error,
    @Default([]) List<Course> courses,
  }) = Error;
}
