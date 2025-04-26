import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_bloc_event.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_bloc_state.dart';
import 'package:learning_platform/src/feature/admin/data/repository/i_admin_repository.dart';
import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';

class AdminUsersBloc extends Bloc<AdminUsersBlocEvent, AdminUsersBlocState>
    with SetStateMixin {
  final IAdminRepository _repo;

  AdminUsersBloc({
    required IAdminRepository repository,
    AdminUsersBlocState? initialState,
  })  : _repo = repository,
        super(
          initialState ?? const AdminUsersBlocState.idle(),
        ) {
    on<AdminUsersBlocEvent>(
      (event, emit) => switch (event) {
        FetchUsersEvent() => _fetchUsers(event, emit),
        ChangeUserRoleEvent() => _changeUserRole(event, emit),
        DeleteUserEvent() => _deleteUser(event, emit),
      },
    );
  }

  Future<void> _fetchUsers(
    FetchUsersEvent e,
    Emitter<AdminUsersBlocState> emit,
  ) async {
    emit(
      AdminUsersBlocState.loading(
        users: state.users,
      ),
    );
    try {
      final list = await _repo.getUsers(e.searchQuery);
      emit(
        AdminUsersBlocState.idle(
          users: list,
        ),
      );
    } on Object catch (e, st) {
      emit(
        AdminUsersBlocState.error(
          users: state.users,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _changeUserRole(
    ChangeUserRoleEvent e,
    Emitter<AdminUsersBlocState> emit,
  ) async {
    emit(
      AdminUsersBlocState.loading(
        users: state.users,
      ),
    );
    try {
      final userRoleRequest = UserRoleRequest(id: e.userId, role: e.role);
      await _repo.changeUserRole(userRoleRequest);
      final list = await _repo.getUsers('');
      emit(
        AdminUsersBlocState.idle(
          users: list,
        ),
      );
    } on Object catch (e, st) {
      emit(
        AdminUsersBlocState.error(
          users: state.users,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _deleteUser(
    DeleteUserEvent e,
    Emitter<AdminUsersBlocState> emit,
  ) async {
    emit(
      AdminUsersBlocState.loading(
        users: state.users,
      ),
    );
    try {
      await _repo.deleteUser(e.userId);
      final list = await _repo.getUsers('');
      emit(
        AdminUsersBlocState.idle(
          users: list,
        ),
      );
    } on Object catch (e, st) {
      emit(
        AdminUsersBlocState.error(
          users: state.users,
          error: e.toString(),
        ),
      );
      onError(e, st);
    }
  }
}
