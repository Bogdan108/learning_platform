import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_event.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/data/repository/i_profile_repository.dart';
import 'package:learning_platform/src/feature/profile/model/user.dart';

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> with SetStateMixin {
  final IProfileRepository _profileRepository;

  ProfileBloc({
    required IProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(ProfileBlocState.idle(profileInfo: User.unauthorized())) {
    on<ProfileBlocEvent>(
      (event, emit) => switch (event) {
        FetchUserInfoEvent() => _fetchUserInfo(event, emit),
        EditUserInfoEvent() => _editUserInfo(event, emit),
      },
    );
  }

  Future<void> _fetchUserInfo(
    FetchUserInfoEvent event,
    Emitter<ProfileBlocState> emit,
  ) async {
    emit(ProfileBlocState.loading(profileInfo: state.profileInfo));
    try {
      final profileInfo = await _profileRepository.getUserInfo();
      emit(ProfileBlocState.idle(profileInfo: profileInfo));
    } catch (ex, stackTrace) {
      emit(
        ProfileBlocState.error(
          profileInfo: state.profileInfo,
          error: 'Ошибка загрузки информации о пользователе',
          event: event,
        ),
      );
      onError(ex, stackTrace);
    }
  }

  Future<void> _editUserInfo(
    EditUserInfoEvent event,
    Emitter<ProfileBlocState> emit,
  ) async {
    emit(ProfileBlocState.loading(profileInfo: state.profileInfo));
    try {
      await _profileRepository.editUserInfo(
        password: event.password,
        fullName: event.fullName,
      );

      final profileInfo = await _profileRepository.getUserInfo();
      emit(ProfileBlocState.idle(profileInfo: profileInfo));
    } catch (ex, stackTrace) {
      emit(
        ProfileBlocState.error(
          profileInfo: state.profileInfo,
          error: 'Ошибка изменения информации о пользователе',
          event: event,
        ),
      );
      onError(ex, stackTrace);
    }
  }
}
