import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/courses/model/course.dart';

part 'admin_courses_bloc_state.freezed.dart';

@freezed
sealed class AdminCoursesBlocState with _$AdminCoursesBlocState {
  const factory AdminCoursesBlocState.idle({
    @Default([]) List<Course> courses,
  }) = Idle;

  const factory AdminCoursesBlocState.loading({
    @Default([]) List<Course> courses,
  }) = Loading;

  const factory AdminCoursesBlocState.error({
    required String error,
    @Default([]) List<Course> courses,
  }) = Error;
}
