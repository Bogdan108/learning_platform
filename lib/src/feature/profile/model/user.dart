import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required UserName fullName,
    required UserRole role,
    required String email,
  }) = _User;

  factory User.unauthorized() =>
      User(fullName: UserName.empty(), role: UserRole.unauthorized, email: '');

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
