import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'admin_users_event.freezed.dart';

@freezed
sealed class AdminUsersEvent with _$AdminUsersEvent {
  const factory AdminUsersEvent.fetchUsers({
    required String searchQuery,
  }) = AdminUsersEvent$FetchUsers;

  const factory AdminUsersEvent.changeUserRole({
    required String userId,
    required UserRole role,
  }) = AdminUsersEvent$ChangeUserRole;

  const factory AdminUsersEvent.deleteUser({
    required String userId,
  }) = AdminUsersEvent$DeleteUser;
}
