import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/widget/custom_search_field.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_bloc.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_bloc_event.dart';
import 'package:learning_platform/src/feature/admin/bloc/admin_users/admin_users_bloc_state.dart';
import 'package:learning_platform/src/feature/admin/data/data_source/admin_data_source.dart';
import 'package:learning_platform/src/feature/admin/data/repository/admin_repository.dart';
import 'package:learning_platform/src/feature/admin/widget/components/delete_user_dialog.dart';
import 'package:learning_platform/src/feature/admin/widget/components/edit_role_dialog.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class UsersManagePage extends StatefulWidget {
  const UsersManagePage({super.key});

  @override
  State<UsersManagePage> createState() => _UsersManagePageState();
}

class _UsersManagePageState extends State<UsersManagePage> {
  late final AdminUsersBloc _adminBloc;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    _adminBloc = AdminUsersBloc(
      repository: AdminRepository(
        dataSource: AdminDataSource(dio: deps.dio),
        tokenStorage: deps.tokenStorage,
        orgIdStorage: deps.organizationIdStorage,
      ),
    )..add(const AdminUsersBlocEvent.fetchUsers(searchQuery: ''));
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _adminBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Управление пользователями'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomSearchField(
                hintText: 'Поиск',
                controller: _searchController,
                onChanged: (q) => _adminBloc
                    .add(AdminUsersBlocEvent.fetchUsers(searchQuery: q)),
              ),
            ),
            Expanded(
              child: BlocBuilder<AdminUsersBloc, AdminUsersBlocState>(
                bloc: _adminBloc,
                builder: (context, state) => switch (state) {
                  Loading() => const CircularProgressIndicator.adaptive(),
                  _ => ListView.separated(
                      itemCount: state.users.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(color: Colors.blue, height: 1),
                      ),
                      itemBuilder: (context, i) {
                        final u = state.users[i];
                        final name = '${u.fullName.secondName} '
                            '${u.fullName.firstName[0]}.${u.fullName.middleName[0]}.';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.role.name,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      u.email,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 16,
                                  ),
                                  onPressed: () => EditRoleDialog(
                                    role: u.role,
                                    onTapCallback: (role) => _adminBloc.add(
                                      AdminUsersBlocEvent.changeUserRole(
                                        userId: u.id,
                                        role: role,
                                      ),
                                    ),
                                  ).show(context),
                                ),
                              ),
                              Flexible(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                  onPressed: () => DeleteUserDialog(
                                    onTapCallback: () => _adminBloc.add(
                                      AdminUsersBlocEvent.deleteUser(
                                        userId: u.id,
                                      ),
                                    ),
                                  ).show(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                },
              ),
            ),
          ],
        ),
      );
}
