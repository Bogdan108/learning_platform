import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

part 'student_answer.freezed.dart';
part 'student_answer.g.dart';

@freezed
abstract class StudentAnswer with _$StudentAnswer {
  const factory StudentAnswer({
    required String userId,
    @JsonKey(name: 'full_name') required UserName name,
    required bool isEvaluated,
  }) = _StudentAnswer;

  factory StudentAnswer.fromJson(Map<String, Object?> json) =>
      _$StudentAnswerFromJson(json);
}
