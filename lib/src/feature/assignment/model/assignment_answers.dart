import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/student_answer.dart';

part 'assignment_answers.freezed.dart';
part 'assignment_answers.g.dart';

@freezed
abstract class AssignmentAnswers with _$AssignmentAnswers {
  const factory AssignmentAnswers({
    @JsonKey(name: 'assignment_id') required String id,
    @JsonKey(name: 'assignment_name') required String name,
    required List<StudentAnswer> students,
  }) = _AssignmentAnswers;

  factory AssignmentAnswers.fromJson(Map<String, Object?> json) =>
      _$AssignmentAnswersFromJson(json);
}
