import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

part 'admin_users_bloc_event.freezed.dart';

@freezed
sealed class AdminUsersBlocEvent with _$AdminUsersBlocEvent {
  const factory AdminUsersBlocEvent.fetchUsers({
    required String searchQuery,
  }) = FetchUsersEvent;

  const factory AdminUsersBlocEvent.changeUserRole({
    required String userId,
    required UserRole role,
  }) = ChangeUserRoleEvent;

  const factory AdminUsersBlocEvent.deleteUser({
    required String userId,
  }) = DeleteUserEvent;
}
