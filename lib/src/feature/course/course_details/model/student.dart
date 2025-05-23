import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
abstract class Student with _$Student {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Student({
    required String id,
    @JsonKey(name: 'full_name') required UserName fullName,
    required String email,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
