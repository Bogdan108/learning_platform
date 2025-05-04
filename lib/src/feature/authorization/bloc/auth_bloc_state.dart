import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';

part 'auth_bloc_state.freezed.dart';

/// States for [AuthBloc]
@freezed
sealed class AuthBlocState with _$AuthBlocState {
  const factory AuthBlocState.idle({
    required String token,
    required AuthenticationStatus status,
  }) = Idle;

  const factory AuthBlocState.loading({
    required String token,
    required AuthenticationStatus status,
  }) = Loading;

  const factory AuthBlocState.success({
    required String token,
    required AuthenticationStatus status,
  }) = Success;

  const factory AuthBlocState.error({
    required String token,
    required AuthenticationStatus status,
    required String error,
  }) = Error;
}
