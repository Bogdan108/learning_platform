import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/core/widget/custom_text_field.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_event.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({
    required this.user,
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _secondNameController;
  late final TextEditingController _middleNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.user.fullName.firstName);
    _secondNameController =
        TextEditingController(text: widget.user.fullName.secondName);
    _middleNameController =
        TextEditingController(text: widget.user.fullName.middleName);
  }

  @override
  void dispose() {
    _secondNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title:
              const Text('Редактирование данных', textAlign: TextAlign.center),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ListView(
            children: [
              CustomTextField(
                label: 'Фамилия',
                controller: _secondNameController,
              ),
              CustomTextField(
                label: 'Имя',
                controller: _firstNameController,
              ),
              CustomTextField(
                label: 'Отчество',
                controller: _middleNameController,
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: CustomElevatedButton(
                  onPressed: () {
                    DependenciesScope.of(context).profileBloc.add(
                          ProfileBlocEvent.editUserInfo(
                              fullName: UserName(
                            firstName: _firstNameController.text,
                            secondName: _secondNameController.text,
                            middleName: _middleNameController.text,
                          )),
                        );
                    context.pop();
                  },
                  title: 'Сохранить',
                ),
              ),
            ],
          ),
        ),
      );
}
