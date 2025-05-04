import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
part 'task_request.freezed.dart';
part 'task_request.g.dart';

@freezed
abstract class TaskRequest with _$TaskRequest {
  const factory TaskRequest({
    @JsonKey(name: 'question_type') required QuestionType questionType,
    @JsonKey(name: 'answer_type') required AnswerType answerType,
    @JsonKey(name: 'question_text') String? questionText,
    @JsonKey(name: 'answer_variants') List<String>? answerVariants,
  }) = _TaskRequest;

  factory TaskRequest.fromJson(Map<String, dynamic> json) =>
      _$TaskRequestFromJson(json);
}
