import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_event.dart';
import 'package:learning_platform/src/feature/admin/model/admin_user.dart';

part 'admin_users_state.freezed.dart';

@freezed
sealed class AdminUsersState with _$AdminUsersState {
  const factory AdminUsersState.idle({
    @Default([]) List<AdminUser> users,
  }) = AdminUsersState$Idle;

  const factory AdminUsersState.loading({
    @Default([]) List<AdminUser> users,
  }) = AdminUsersState$Loading;

  const factory AdminUsersState.error({
    required String error,
    @Default([]) List<AdminUser> users,
    AdminUsersEvent? event,
  }) = AdminUsersState$Error;
}
