import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';

part 'auth_bloc_state.freezed.dart';

/// States for [AuthBloc]
@freezed
sealed class AuthBlocState with _$AuthBlocState {
  const factory AuthBlocState.idle({
    required AuthenticationStatus status,
  }) = Idle;

  const factory AuthBlocState.loading({
    required AuthenticationStatus status,
  }) = Loading;

  const factory AuthBlocState.error({
    required AuthenticationStatus status,
    required String error,
  }) = Error;
}
