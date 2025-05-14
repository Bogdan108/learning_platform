import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/courses/course/bloc/course_event.dart';
import 'package:learning_platform/src/feature/courses/course/model/course_additions.dart';
import 'package:learning_platform/src/feature/courses/course/model/student.dart';

part 'course_state.freezed.dart';

@freezed
sealed class CourseState with _$CourseState {
  const factory CourseState.idle({
    required CourseAdditions additions,
    required List<Student> students,
  }) = CourseState$Idle;

  const factory CourseState.loading({
    required CourseAdditions additions,
    required List<Student> students,
  }) = CourseState$Loading;

  const factory CourseState.error({
    required String error,
    required CourseAdditions additions,
    required List<Student> students,
    CourseEvent? event,
  }) = CourseState$Error;
}
