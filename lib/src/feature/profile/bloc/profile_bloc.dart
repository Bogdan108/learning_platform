import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_event.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/data/repository/i_profile_repository.dart';

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileBlocState>
    with SetStateMixin {
  final IProfileRepository _profileRepository;

  ProfileBloc({
    required IProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(const ProfileBlocState.idle()) {
    on<ProfileBlocEvent>((event, emit) async {
      switch (event) {
        case FetchUserInfoEvent(
            organizationId: final organizationId,
            token: final token,
          ):
          emit(const ProfileBlocState.loading());
          try {
            final profileInfo =
                await _profileRepository.getUserInfo(organizationId, token);
            emit(ProfileBlocState.idle(profileInfo: profileInfo));
          } catch (ex, stackTrace) {
            emit(ProfileBlocState.error(error: ex.toString()));
            onError(ex, stackTrace);
          }
      }
    });
  }
}
