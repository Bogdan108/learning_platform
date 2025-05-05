// lib/src/feature/answers/bloc/answers_bloc_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/assignment_answers.dart';
part 'answers_bloc_state.freezed.dart';

@freezed
sealed class AnswersBlocState with _$AnswersBlocState {
  const factory AnswersBlocState.idle({
    required List<AssignmentAnswers> data,
  }) = Idle;

  const factory AnswersBlocState.loading({
    required List<AssignmentAnswers> data,
  }) = Loading;

  const factory AnswersBlocState.error({
    required String error,
    required List<AssignmentAnswers> data,
  }) = Error;
}
