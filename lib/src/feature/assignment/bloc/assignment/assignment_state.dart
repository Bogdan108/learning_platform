import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/bloc/assignment/assignment_event.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';

part 'assignment_state.freezed.dart';

@freezed
sealed class AssignmentState with _$AssignmentState {
  const factory AssignmentState.idle({
    required List<Assignment> items,
  }) = AssignmentState$Idle;

  const factory AssignmentState.loading({
    required List<Assignment> items,
  }) = AssignmentState$Loading;

  const factory AssignmentState.error({
    required String error,
    required List<Assignment> items,
    AssignmentEvent? event,
  }) = AssignmentState$Error;
}
