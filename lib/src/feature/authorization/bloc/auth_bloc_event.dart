import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

part 'auth_bloc_event.freezed.dart';

/// Events for [AuthBloc]
@freezed
sealed class AuthBlocEvent with _$AuthBlocEvent {
  /// Event to sign in with Email and Password
  const factory AuthBlocEvent.signIn({
    required String organizationId,
    required String email,
    required String password,
  }) = SignInEvent;

  /// Event to register new user
  const factory AuthBlocEvent.register({
    required String organizationId,
    required String email,
    required String password,
    required UserName userName,
  }) = RegisterEvent;

  /// Event to verify new user email
  const factory AuthBlocEvent.verifyEmail({
    required String code,
  }) = VerifyEmailEvent;

  /// Event to sign out
  const factory AuthBlocEvent.signOut() = SignOutEvent;
}
