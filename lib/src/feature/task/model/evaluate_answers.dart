import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_task.dart';

part 'evaluate_answers.freezed.dart';
part 'evaluate_answers.g.dart';

@freezed
abstract class EvaluateAnswers with _$EvaluateAnswers {
  const factory EvaluateAnswers({
    @JsonKey(name: 'assignment_id') required String id,
    @JsonKey(name: 'assignment_name') required String name,
    required List<EvaluateTask> evaluateTasks,
  }) = _EvaluateAnswers;

  factory EvaluateAnswers.empty() =>
      const EvaluateAnswers(evaluateTasks: [], id: '', name: '');

  factory EvaluateAnswers.fromJson(Map<String, Object?> json) =>
      _$EvaluateAnswersFromJson(json);
}
