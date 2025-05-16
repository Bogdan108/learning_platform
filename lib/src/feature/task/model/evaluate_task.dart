import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
part 'evaluate_task.freezed.dart';
part 'evaluate_task.g.dart';

@freezed
abstract class EvaluateTask with _$EvaluateTask {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory EvaluateTask({
    required String id,
    @JsonKey(name: 'question_type') required QuestionType questionType,
    @JsonKey(name: 'answer_type') required AnswerType answerType,
    @JsonKey(name: 'question_text') String? questionText,
    @JsonKey(name: 'question_file') String? questionFile,
    @JsonKey(name: 'answer_variants') List<String>? answerVariants,
    @JsonKey(name: 'answer_text') String? answerText,
    @JsonKey(name: 'answer_file') String? answerFile,
    int? assessment,
    @JsonKey(name: 'feedback') String? feedback,
  }) = _EvaluateTask;

  factory EvaluateTask.fromJson(Map<String, dynamic> json) =>
      _$EvaluateTaskFromJson(json);
}
