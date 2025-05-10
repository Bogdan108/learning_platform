import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_courses.dart';

part 'student_assignments_state.freezed.dart';

@freezed
sealed class StudentAssignmentsState with _$StudentAssignmentsState {
  const factory StudentAssignmentsState.idle({
    required List<AssignmentCourses> items,
  }) = StudentAssignmentsState$Idle;

  const factory StudentAssignmentsState.loading({
    required List<AssignmentCourses> items,
  }) = StudentAssignmentsState$Loading;

  const factory StudentAssignmentsState.error({
    required String error,
    required List<AssignmentCourses> items,
  }) = StudentAssignmentsState$Error;
}
