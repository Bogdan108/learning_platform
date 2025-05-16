import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'user_role_request.freezed.dart';
part 'user_role_request.g.dart';

@freezed
abstract class UserRoleRequest with _$UserRoleRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserRoleRequest({
    required String id,
    required UserRole role,
  }) = _UserRoleRequest;

  factory UserRoleRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRoleRequestFromJson(json);
}
