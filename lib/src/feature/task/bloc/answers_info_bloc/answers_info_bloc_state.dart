import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/assignment_answers.dart';
part 'answers_info_bloc_state.freezed.dart';

@freezed
sealed class AnswersInfoBlocState with _$AnswersInfoBlocState {
  const factory AnswersInfoBlocState.idle({
    required List<AssignmentAnswers> data,
  }) = Idle;

  const factory AnswersInfoBlocState.loading({
    required List<AssignmentAnswers> data,
  }) = Loading;

  const factory AnswersInfoBlocState.error({
    required String error,
    required List<AssignmentAnswers> data,
  }) = Error;
}
