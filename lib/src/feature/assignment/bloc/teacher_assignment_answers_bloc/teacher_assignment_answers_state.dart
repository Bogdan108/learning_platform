import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/bloc/teacher_assignment_answers_bloc/teacher_assignment_answers_event.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_answers.dart';
part 'teacher_assignment_answers_state.freezed.dart';

@freezed
sealed class TeacherAssignmentAnswersState
    with _$TeacherAssignmentAnswersState {
  const factory TeacherAssignmentAnswersState.idle({
    required List<AssignmentAnswers> data,
  }) = TeacherAssignmentAnswersState$Idle;

  const factory TeacherAssignmentAnswersState.loading({
    required List<AssignmentAnswers> data,
  }) = TeacherAssignmentAnswersState$Loading;

  const factory TeacherAssignmentAnswersState.error({
    required String error,
    required List<AssignmentAnswers> data,
    TeacherAssignmentAnswersEvent? event,
  }) = TeacherAssignmentAnswersState$Error;
}
