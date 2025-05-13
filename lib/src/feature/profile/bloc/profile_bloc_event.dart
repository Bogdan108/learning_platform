import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

part 'profile_bloc_event.freezed.dart';

@freezed
sealed class ProfileBlocEvent with _$ProfileBlocEvent {
  const factory ProfileBlocEvent.fetchUserInfo() = FetchUserInfoEvent;
  const factory ProfileBlocEvent.editUserInfo({
    String? password,
    UserName? fullName,
  }) = EditUserInfoEvent;
}
