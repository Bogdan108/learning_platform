import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/common/widget/text_fields/custom_text_field.dart';
import 'package:learning_platform/src/core/constant/app_strings.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/authorization/widget/components/auth_button.dart';
import 'package:learning_platform/src/feature/authorization/widget/components/change_auth_type_button.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = DependenciesScope.of(context).authBloc;
  }

  String? firstName;
  String? lastName;
  String? username;
  String? password;
  String? organizationId;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.registration,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        hintText: AppStrings.organizationId,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseEnterSomething;
                          }
                          organizationId = value;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        hintText: AppStrings.firstName,
                        onChanged: (value) => firstName = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseEnterSomething;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        hintText: AppStrings.lastName,
                        onChanged: (value) => lastName = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseEnterSomething;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        hintText: AppStrings.login,
                        onChanged: (value) => username = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseEnterSomething;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField.password(
                        onChanged: (value) => password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseEnterSomething;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthButton(
                      title: AppStrings.register,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // Переход на страницу верификации email с передачей параметров
                          context.push(
                            '/register/validate_code',
                            extra: {
                              'firstName': firstName!,
                              'lastName': lastName!,
                              'email': username!,
                              'password': password!,
                              'organizationId': organizationId!,
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ChangeAuthTypeButton(
                      title: AppStrings.haveAnAccount,
                      subTitle: AppStrings.comeIn,
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
