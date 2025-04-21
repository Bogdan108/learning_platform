// ignore_for_file: prefer_const_constructors, inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({Key? key}) : super(key: key);

  @override
  State<AdminUserManagementPage> createState() =>
      _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  // Мок-данные пользователей
  final List<User> _users = [
    User(
      fullName:
          UserName(firstName: 'В', secondName: 'Карлова', middleName: 'Ю'),
      email: 'victoria@example.com',
      role: UserRole.admin,
    ),
    User(
      fullName: UserName(firstName: 'И', secondName: 'Иванов', middleName: 'И'),
      email: 'ivanov@example.com',
      role: UserRole.teacher,
    ),
    User(
      fullName:
          UserName(firstName: 'Т', secondName: 'Костюкова', middleName: 'П'),
      email: 'kost@example.com',
      role: UserRole.student,
    ),
    User(
      fullName:
          UserName(firstName: 'Е', secondName: 'Осипова', middleName: 'Н'),
      email: 'osipova@example.com',
      role: UserRole.student,
    ),
  ];

  // Для поиска
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredUsers = _users
        .where((user) => user.fullName.secondName.toLowerCase().contains(query))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Поиск',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: filteredUsers.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Divider(
                height: 1,
                color: Colors.blue,
              ),
            ),
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return ListTile(
                title: Text(
                  '${user.fullName.secondName} ${user.fullName.firstName} ${user.fullName.middleName}',
                ),
                subtitle: Text('${user.email}  |  ${_roleToString(user.role)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showChangeRoleDialog(user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _showDeleteUserDialog(user),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Администратор';
      case UserRole.teacher:
        return 'Учитель';
      case UserRole.student:
        return 'Ученик';
      case UserRole.unauthorized:
        return 'Неавторизован';
    }
  }

  void _showChangeRoleDialog(User user) {
    showDialog(
      context: context,
      builder: (_) {
        UserRole? selectedRole = user.role;
        return AlertDialog(
          title: const Text('Выберите новую роль'),
          content: DropdownButton<UserRole>(
            isExpanded: true,
            value: selectedRole,
            items: const [
              DropdownMenuItem(value: UserRole.teacher, child: Text('Учитель')),
              DropdownMenuItem(
                  value: UserRole.admin, child: Text('Администратор')),
              DropdownMenuItem(value: UserRole.student, child: Text('Ученик')),
            ],
            onChanged: (value) {
              setState(() => selectedRole = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final index = _users.indexOf(user);
                  _users[index] = User(
                    fullName: user.fullName,
                    role: selectedRole!,
                    email: user.email,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Применить'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteUserDialog(User user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Удалить пользователя ${user.fullName.secondName} ${user.fullName.firstName} ${user.fullName.middleName},?',
        ),
        content: const Text('Вы действительно хотите удалить пользователя?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _users.remove(user);
              });
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
