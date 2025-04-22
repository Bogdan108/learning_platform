import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/common/widget/custom_snackbar.dart';
import 'package:learning_platform/src/core/constant/app_strings.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_event.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_state.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    super.key,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  late final AuthBloc authBloc;
  late final List<TextEditingController> _textControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    authBloc = DependenciesScope.of(context).authBloc
      ..add(const AuthBlocEvent.sendEmailCode());
    _textControllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _textControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthBlocState>(
        bloc: authBloc,
        listener: (context, state) {
          switch (state) {
            case Idle(status: AuthenticationStatus.authenticated):
              context.go('/home');
            // case Error(error: final error):
            //   CustomSnackBar.showError(context, message: error);
            default:
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppStrings.validateEmail,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _textControllers.length,
                      (index) => Flexible(
                        child: TextField(
                          controller: _textControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          onChanged: (value) {
                            if (value.length == 1 &&
                                index < _textControllers.length - 1) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            checkCode();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void checkCode() {
    final enteredCode = _textControllers.map((digit) => digit.text).join();
    if (enteredCode.length == _textControllers.length) {
      CustomSnackBar.showSuccessful(context, message: 'Успешная авторизация!');
      context.go('/courses');
      // authBloc.add(
      //   AuthBlocEvent.verifyEmail(
      //     code: enteredCode,
      //   ),
      //);
    }
  }
}
