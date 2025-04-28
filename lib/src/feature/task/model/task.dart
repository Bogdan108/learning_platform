import 'package:freezed_annotation/freezed_annotation.dart';
part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    @JsonKey(name: 'question_type') required String questionType,
    @JsonKey(name: 'question_text') String? questionText,
    @JsonKey(name: 'question_file') String? questionFile,
    @JsonKey(name: 'answer_type') required String answerType,
    @JsonKey(name: 'answer_variants') List<String>? answerVariants,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
