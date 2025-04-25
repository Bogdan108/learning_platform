import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/admin/model/admin_user.dart';

part 'admin_users_bloc_state.freezed.dart';

@freezed
sealed class AdminUsersBlocState with _$AdminUsersBlocState {
  const factory AdminUsersBlocState.idle({
    @Default([]) List<AdminUser> users,
  }) = Idle;

  const factory AdminUsersBlocState.loading({
    @Default([]) List<AdminUser> users,
  }) = Loading;

  const factory AdminUsersBlocState.error({
    required String error,
    @Default([]) List<AdminUser> users,
  }) = Error;
}
