import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';

part 'profile_bloc_state.freezed.dart';

@freezed
sealed class ProfileBlocState with _$ProfileBlocState {
  /// Начальное и успешное состояние, когда имеется информация о профиле (может быть null)
  const factory ProfileBlocState.idle({
    User? profileInfo,
  }) = Idle;

  /// Состояние загрузки
  const factory ProfileBlocState.loading() = Loading;

  /// Состояние ошибки с текстом ошибки
  const factory ProfileBlocState.error({
    required String error,
  }) = Error;
}
