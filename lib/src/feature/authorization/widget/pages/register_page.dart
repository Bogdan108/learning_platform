import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/widget/custom_snackbar.dart';
import 'package:learning_platform/src/core/widget/text_fields/custom_text_field.dart';
import 'package:learning_platform/src/core/constant/app_strings.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_event.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_state.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';
import 'package:learning_platform/src/feature/authorization/widget/components/auth_button.dart';
import 'package:learning_platform/src/feature/authorization/widget/components/change_auth_type_button.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthBloc authBloc;
  late final ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    profileBloc = deps.profileBloc;
    authBloc = deps.authBloc;
  }

  String? firstName;
  String? lastName;
  String? middleName;
  String? email;
  String? password;
  String? organizationId;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthBlocState>(
        bloc: authBloc,
        listener: (context, state) {
          switch (state) {
            case Success(status: AuthenticationStatus.authenticated):
              context.push(
                '/register/validate_code',
                extra: {
                  'firstName': firstName!,
                  'lastName': lastName!,
                  'email': email!,
                  'password': password!,
                },
              );
            case Error(error: final error):
              CustomSnackBar.showError(context, message: error);
            default:
              break;
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Scaffold(
                body: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          AppStrings.registration,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
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
                          hintText: AppStrings.middleName,
                          onChanged: (value) => middleName = value,
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
                          onChanged: (value) => email = value,
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
                            authBloc.add(
                              AuthBlocEvent.register(
                                organizationId: organizationId ?? '1',
                                email: email!,
                                password: password!,
                                userName: UserName(
                                  firstName: firstName ?? '',
                                  secondName: lastName ?? '',
                                  middleName: middleName ?? '',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Flexible(
                        child: ChangeAuthTypeButton(
                          title: AppStrings.haveAnAccount,
                          subTitle: AppStrings.comeIn,
                          onPressed: () => context.goNamed('login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
