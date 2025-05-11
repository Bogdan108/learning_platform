import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_event.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_state.dart';
import 'package:learning_platform/src/feature/admin/data/repository/i_admin_repository.dart';
import 'package:learning_platform/src/feature/admin/model/user_role_request.dart';

class AdminUsersBloc extends Bloc<AdminUsersEvent, AdminUsersState> with SetStateMixin {
  final IAdminRepository _repo;

  AdminUsersBloc({
    required IAdminRepository repository,
    AdminUsersState? initialState,
  })  : _repo = repository,
        super(
          initialState ?? const AdminUsersState.idle(),
        ) {
    on<AdminUsersEvent>(
      (event, emit) => switch (event) {
        AdminUsersEvent$FetchUsers() => _fetchUsers(event, emit),
        AdminUsersEvent$ChangeUserRole() => _changeUserRole(event, emit),
        AdminUsersEvent$DeleteUser() => _deleteUser(event, emit),
      },
    );
  }

  Future<void> _fetchUsers(
    AdminUsersEvent$FetchUsers event,
    Emitter<AdminUsersState> emit,
  ) async {
    emit(
      AdminUsersState.loading(
        users: state.users,
      ),
    );
    try {
      final list = await _repo.getUsers(
        event.searchQuery,
      );
      emit(
        AdminUsersState.idle(
          users: list,
        ),
      );
    } on Object catch (e, st) {
      emit(
        AdminUsersState.error(
          users: state.users,
          error: 'Ошибка загрузки пользователей',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _changeUserRole(
    AdminUsersEvent$ChangeUserRole event,
    Emitter<AdminUsersState> emit,
  ) async {
    emit(
      AdminUsersState.loading(
        users: state.users,
      ),
    );
    try {
      final userRoleRequest = UserRoleRequest(
        id: event.userId,
        role: event.role,
      );
      await _repo.changeUserRole(userRoleRequest);
      final list = await _repo.getUsers('');
      emit(
        AdminUsersState.idle(
          users: list,
        ),
      );
    } on Object catch (e, st) {
      emit(
        AdminUsersState.error(
          users: state.users,
          error: 'Ошибка изменения роли пользователя',
          event: event,
        ),
      );
      onError(e, st);
    }
  }

  Future<void> _deleteUser(
    AdminUsersEvent$DeleteUser event,
    Emitter<AdminUsersState> emit,
  ) async {
    emit(
      AdminUsersState.loading(
        users: state.users,
      ),
    );
    try {
      await _repo.deleteUser(event.userId);
      final list = await _repo.getUsers('');
      emit(
        AdminUsersState.idle(
          users: list,
        ),
      );
    } on Object catch (e, st) {
      emit(
        AdminUsersState.error(
          users: state.users,
          error: 'Ошибка удаления пользователя',
          event: event,
        ),
      );
      onError(e, st);
    }
  }
}
