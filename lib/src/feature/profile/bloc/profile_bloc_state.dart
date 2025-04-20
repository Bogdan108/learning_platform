import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';

part 'profile_bloc_state.freezed.dart';

@freezed
sealed class ProfileBlocState with _$ProfileBlocState {
  const factory ProfileBlocState.idle({
    User? profileInfo,
  }) = Idle;

  const factory ProfileBlocState.loading() = Loading;

  const factory ProfileBlocState.error({
    required String error,
  }) = Error;
}
