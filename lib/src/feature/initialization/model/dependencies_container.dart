import 'package:dio/dio.dart';
import 'package:learning_platform/src/core/constant/application_config.dart';
import 'package:learning_platform/src/core/utils/logger/logger.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/organization_id_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';

/// {@template dependencies_container}
/// Container used to reuse dependencies across the application.
///
/// {@macro composition_process}
/// {@endtemplate}
class DependenciesContainer {
  /// {@macro dependencies_container}
  const DependenciesContainer({
    required this.logger,
    required this.config,
    required this.dio,
    required this.tokenStorage,
    required this.organizationIdStorage,
    required this.authBloc,
    required this.profileBloc,
  });

  /// [Logger] instance, used to log messages.
  final Logger logger;

  /// [ApplicationConfig] instance, contains configuration of the application.
  final ApplicationConfig config;

  /// [Dio] instance, used to make HTTP requests.
  final Dio dio;

  ///[TokenStorage] instance, used to manage user token.
  final TokenStorage tokenStorage;

  ///[OrganizationIdStorage] instance, used to manage org id.
  final OrganizationIdStorage organizationIdStorage;

  ///[AuthBloc] instance, used to manage authorization.
  final AuthBloc authBloc;

  ///[ProfileBloc] instance, used to get info about user.
  final ProfileBloc profileBloc;
}

/// {@template testing_dependencies_container}
/// A special version of [DependenciesContainer] that is used in tests.
///
/// In order to use [DependenciesContainer] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
/// {@endtemplate}
base class TestDependenciesContainer implements DependenciesContainer {
  /// {@macro testing_dependencies_container}
  const TestDependenciesContainer();

  @override
  Object noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} dependency, but '
      'it was not provided. Please provide the dependency in the test. '
      'You can do it by extending this class and providing the dependency.',
    );
  }
}
