import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment.dart';

part 'assignment_bloc_state.freezed.dart';

@freezed
sealed class AssignmentBlocState with _$AssignmentBlocState {
  const factory AssignmentBlocState.idle({
    required List<Assignment> items,
  }) = Idle;

  const factory AssignmentBlocState.loading({
    required List<Assignment> items,
  }) = Loading;

  const factory AssignmentBlocState.error({
    required String error,
    required List<Assignment> items,
  }) = Error;
}
