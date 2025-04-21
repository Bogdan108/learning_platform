import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/course/model/course_additions.dart';
import 'package:learning_platform/src/feature/course/model/student.dart';

part 'course_bloc_state.freezed.dart';

@freezed
sealed class CourseBlocState with _$CourseBlocState {
  const factory CourseBlocState.idle({
    required CourseAdditions additions,
    required List<Student> students,
  }) = Idle;

  const factory CourseBlocState.loading({
    required CourseAdditions additions,
    required List<Student> students,
  }) = Loading;

  const factory CourseBlocState.error({
    required String error,
    required CourseAdditions additions,
    required List<Student> students,
  }) = Error;
}
