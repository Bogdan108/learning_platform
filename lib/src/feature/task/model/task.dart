import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    @JsonKey(name: 'question_type') required QuestionType questionType,
    @JsonKey(name: 'answer_type') required AnswerType answerType,
    @JsonKey(name: 'question_text') String? questionText,
    @JsonKey(name: 'question_file') String? questionFile,
    @JsonKey(name: 'answer_variants') List<String>? answerVariants,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
