import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_bloc_event.freezed.dart';

@freezed
abstract class ProfileBlocEvent with _$ProfileBlocEvent {
  /// Событие для получения информации о пользователе
  const factory ProfileBlocEvent.fetchUserInfo({
    required String organizationId,
    required String token,
  }) = FetchUserInfoEvent;
}
