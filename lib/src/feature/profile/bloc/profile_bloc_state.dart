import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_event.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';

part 'profile_bloc_state.freezed.dart';

@freezed
sealed class ProfileBlocState with _$ProfileBlocState {
  const factory ProfileBlocState.idle({
    required User profileInfo,
  }) = Idle;

  const factory ProfileBlocState.loading({
    required User profileInfo,
  }) = Loading;

  const factory ProfileBlocState.error({
    required String error,
    required User profileInfo,
    ProfileBlocEvent? event,
  }) = Error;
}
