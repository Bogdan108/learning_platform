import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'admin_user.freezed.dart';
part 'admin_user.g.dart';

@freezed
abstract class AdminUser with _$AdminUser {
  const factory AdminUser({
    required String id,
    required UserName fullName,
    required UserRole role,
    required String email,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, Object?> json) =>
      _$AdminUserFromJson(json);
}
