import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/core/utils/set_state_mixin.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_event.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_state.dart';
import 'package:learning_platform/src/feature/authorization/data/repository/i_auth_repository.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:learning_platform/src/feature/profile/data/repository/i_profile_repository.dart';

/// AuthBloc
class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> with SetStateMixin {
  final IAuthRepository _authRepository;
  final IProfileRepository _profileRepository;
  final ProfileBloc _profileBloc;

  /// Create an [AuthBloc]
  ///
  /// This specializes required initialState as it should be preloaded.
  AuthBloc(
    super.initialState, {
    required IAuthRepository authRepository,
    required IProfileRepository profileRepository,
    required ProfileBloc profileBloc,
  })  : _authRepository = authRepository,
        _profileRepository = profileRepository,
        _profileBloc = profileBloc {
    // emit new state when the authentication status changes
    authRepository.authStatus
        .map(
      ($status) => AuthBlocState.idle(
        status: $status,
        token: state.token,
      ),
    )
        .listen(
      ($state) {
        if ($state != state) {
          setState($state);
        }
      },
    );

    on<AuthBlocEvent>(
      (event, emit) => switch (event) {
        SignInEvent() => _signIn(event, emit),
        RegisterEvent() => _register(event, emit),
        VerifyEmailEvent() => _verifyEmail(event, emit),
        SignOutEvent() => _signOut(event, emit),
      },
    );
  }

  Future<void> _signIn(
    SignInEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(
      AuthBlocState.loading(
        status: state.status,
        token: state.token,
      ),
    );

    try {
      final token = await _authRepository.login(
        event.organizationId,
        event.email,
        event.password,
      );

      final user = await _profileRepository.getUserInfo();
      _profileBloc.setState(ProfileBlocState.idle(profileInfo: user));

      emit(
        AuthBlocState.success(
          status: AuthenticationStatus.authenticated,
          token: token,
          role: user.role,
        ),
      );
    } on Object catch (e, stackTrace) {
      emit(
        AuthBlocState.error(
          status: AuthenticationStatus.unauthenticated,
          token: state.token,
          error: e.toString(),
        ),
      );
      onError(e, stackTrace);
    }
  }

  Future<void> _register(
    RegisterEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(
      AuthBlocState.loading(
        status: state.status,
        token: state.token,
      ),
    );

    try {
      final token = await _authRepository.register(
        event.organizationId,
        event.email,
        event.password,
        event.userName,
      );
      await _authRepository.sendCodeToEmail(token);

      final user = await _profileRepository.getUserInfo();

      _profileBloc.setState(ProfileBlocState.idle(profileInfo: user));
      emit(
        AuthBlocState.success(
          status: AuthenticationStatus.authenticated,
          token: token,
          role: user.role,
        ),
      );
    } on Object catch (e, stackTrace) {
      emit(
        AuthBlocState.error(
          status: AuthenticationStatus.unauthenticated,
          token: state.token,
          error: e.toString(),
        ),
      );
      onError(e, stackTrace);
    }
  }

  Future<void> _signOut(
    SignOutEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(
      AuthBlocState.loading(
        status: state.status,
        token: state.token,
      ),
    );

    try {
      await _authRepository.logout();
      emit(
        const AuthBlocState.idle(
          status: AuthenticationStatus.unauthenticated,
          token: '',
        ),
      );
    } on Object catch (e, stackTrace) {
      emit(
        AuthBlocState.error(
          status: AuthenticationStatus.unauthenticated,
          token: state.token,
          error: e.toString(),
        ),
      );
      onError(e, stackTrace);
    }
  }

  Future<void> _verifyEmail(
    VerifyEmailEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    emit(
      AuthBlocState.loading(
        status: state.status,
        token: state.token,
      ),
    );

    try {
      await _authRepository.verifyEmail(event.code);
      final user = await _profileRepository.getUserInfo();

      emit(
        AuthBlocState.success(
          status: AuthenticationStatus.authenticated,
          token: state.token,
          role: user.role,
        ),
      );
    } on Object catch (e, stackTrace) {
      emit(
        AuthBlocState.error(
          status: state.status,
          token: state.token,
          error: e.toString(),
        ),
      );
      onError(e, stackTrace);
    }
  }
}
