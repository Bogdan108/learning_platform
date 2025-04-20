import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_bloc_event.freezed.dart';

@freezed
sealed class ProfileBlocEvent with _$ProfileBlocEvent {
  const factory ProfileBlocEvent.fetchUserInfo({
    required String organizationId,
    required String token,
  }) = FetchUserInfoEvent;
}
