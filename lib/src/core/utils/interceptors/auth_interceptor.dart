import 'package:dio/dio.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_event.dart';

class AuthInterceptor extends Interceptor {
  final AuthBloc _authBloc;

  AuthInterceptor({
    required AuthBloc authBloc,
  }) : _authBloc = authBloc;

  @override
  Future<void> onError(
      DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      _authBloc.add(const AuthBlocEvent.signOut());
    }

    return super.onError(error, handler);
  }
}
