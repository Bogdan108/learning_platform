import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/evaluate_task.dart';

part 'evaluate_answers.freezed.dart';
part 'evaluate_answers.g.dart';

@freezed
abstract class EvaluateAnswers with _$EvaluateAnswers {
  const factory EvaluateAnswers({
    @JsonSerializable(fieldRename: FieldRename.snake)
    @JsonKey(name: 'tasks_info')
    required List<EvaluateTask> evaluateTasks,
  }) = _EvaluateAnswers;

  factory EvaluateAnswers.empty() => const EvaluateAnswers(
        evaluateTasks: [],
      );

  factory EvaluateAnswers.fromJson(Map<String, Object?> json) =>
      _$EvaluateAnswersFromJson(json);
}
