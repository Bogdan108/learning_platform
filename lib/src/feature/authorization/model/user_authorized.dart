import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'user_authorized.freezed.dart';
part 'user_authorized.g.dart';

@freezed
abstract class UserAuthorized with _$UserAuthorized {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserAuthorized({
    required String token,
    required String userId,
    required UserName fullName,
    required String email,
    required UserRole role,
  }) = _UserAuthorized;

  factory UserAuthorized.fromJson(Map<String, dynamic> json) =>
      _$UserAuthorizedFromJson(json);
}
