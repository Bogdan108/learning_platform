import 'package:flutter/material.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class EditRoleDialog extends StatefulWidget {
  final UserRole role;
  final void Function(UserRole role) onTapCallback;

  const EditRoleDialog({
    required this.onTapCallback,
    required this.role,
    super.key,
  });

  Future<bool?> show(BuildContext context) => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => this,
      );

  @override
  State<EditRoleDialog> createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<EditRoleDialog> {
  late UserRole role;

  @override
  void initState() {
    super.initState();
    role = widget.role;
  }

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 8,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Изменить роль',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 9,
              ),
              DropdownButtonFormField<UserRole>(
                value: role,
                items: const [
                  DropdownMenuItem(
                    value: UserRole.student,
                    child: Text('Ученик'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.teacher,
                    child: Text('Учитель'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.admin,
                    child: Text('Админ'),
                  ),
                ],
                onChanged: (v) => role = v ?? UserRole.student,
              ),
              const SizedBox(
                height: 9,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => {
                        widget.onTapCallback(role),
                        Navigator.of(context).pop(true),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Сохранить',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
}
