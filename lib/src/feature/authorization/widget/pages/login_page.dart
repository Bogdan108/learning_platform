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
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_event.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthBloc authBloc;
  late final ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    profileBloc = deps.profileBloc;
    authBloc = deps.authBloc;
  }

  String? username;
  String? password;
  String? organizationId;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthBlocState>(
        bloc: authBloc,
        listener: (context, state) {
          switch (state) {
            case Success(
                status: AuthenticationStatus.authenticated,
                role: final userRole
              ):
              profileBloc.add(ProfileBlocEvent.fetchUserInfo());

              if (userRole == UserRole.admin) {
                context.goNamed('adminCourses');
              } else if (userRole == UserRole.student) {
                context.goNamed('courses');
              } else {
                context.goNamed('teacherCourses');
              }

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
                      const Text(
                        AppStrings.authorization,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextField(
                          hintText: AppStrings.login,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.pleaseEnterSomething;
                            }
                            username = value;
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextField.password(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.pleaseEnterSomething;
                            }
                            password = value;
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        title: AppStrings.comeIn,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            authBloc.add(
                              AuthBlocEvent.signIn(
                                organizationId: organizationId ?? '1',
                                email: username!,
                                password: password!,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      ChangeAuthTypeButton(
                        title: AppStrings.dontHaveAnAccount,
                        subTitle: AppStrings.register,
                        onPressed: () => context.goNamed('register'),
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
