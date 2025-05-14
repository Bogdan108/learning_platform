import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_name.freezed.dart';
part 'user_name.g.dart';

/// Represents a user's name with first, second, and middle name.
@freezed
abstract class UserName with _$UserName {
  @JsonSerializable(fieldRename: FieldRename.snake)

  /// Creates a new [UserName] instance.
  const factory UserName({
    required String firstName,
    required String secondName,
    required String middleName,
  }) = _UserName;

  factory UserName.empty() =>
      const UserName(firstName: '', secondName: '', middleName: '');

  /// Creates a new [UserName] instance from a JSON
  factory UserName.fromJson(Map<String, Object?> json) =>
      _$UserNameFromJson(json);
}
