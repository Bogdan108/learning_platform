import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:learning_platform/src/core/constant/app_strings.dart';
import 'package:learning_platform/src/core/constant/application_config.dart';
import 'package:learning_platform/src/core/utils/error_reporter/error_reporter.dart';
import 'package:learning_platform/src/core/utils/error_reporter/sentry_error_reporter.dart';
import 'package:learning_platform/src/core/utils/logger/logger.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc.dart';
import 'package:learning_platform/src/feature/authorization/bloc/auth_bloc_state.dart';
import 'package:learning_platform/src/feature/authorization/data/data_source/auth_data_source.dart';
import 'package:learning_platform/src/feature/authorization/data/repository/auth_repository.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/organization_id_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';
import 'package:learning_platform/src/feature/initialization/model/dependencies_container.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_event.dart';
import 'package:learning_platform/src/feature/profile/data/data_source/profile_data_source.dart';
import 'package:learning_platform/src/feature/profile/data/repository/profile_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template composition_root}
/// A place where top-level dependencies are initialized.
/// {@endtemplate}
///
/// {@template composition_process}
/// Composition of dependencies is a process of creating and configuring
/// instances of classes that are required for the application to work.
/// {@endtemplate}
final class CompositionRoot {
  /// {@macro composition_root}
  const CompositionRoot({
    required this.config,
    required this.logger,
    required this.errorReporter,
  });

  /// Application configuration
  final ApplicationConfig config;

  /// Logger used to log information during composition process.
  final Logger logger;

  /// Error tracking manager used to track errors in the application.
  final ErrorReporter errorReporter;

  /// Composes dependencies and returns result of composition.
  Future<CompositionResult> compose() async {
    final stopwatch = clock.stopwatch()..start();

    logger.info('Initializing dependencies...');
    // initialize dependencies
    final dependencies = await DependenciesFactory(
      config: config,
      logger: logger,
      errorReporter: errorReporter,
    ).create();

    stopwatch.stop();
    logger.info(
      'Dependencies initialized successfully in ${stopwatch.elapsedMilliseconds} ms.',
    );
    final result = CompositionResult(
      dependencies: dependencies,
      millisecondsSpent: stopwatch.elapsedMilliseconds,
    );

    return result;
  }
}

/// {@template composition_result}
/// Result of composition
///
/// {@macro composition_process}
/// {@endtemplate}
final class CompositionResult {
  /// {@macro composition_result}
  const CompositionResult({
    required this.dependencies,
    required this.millisecondsSpent,
  });

  /// The dependencies container
  final DependenciesContainer dependencies;

  /// The number of milliseconds spent
  final int millisecondsSpent;

  @override
  String toString() => '$CompositionResult('
      'dependencies: $dependencies, '
      'millisecondsSpent: $millisecondsSpent'
      ')';
}

/// Value with time.
typedef ValueWithTime<T> = ({T value, Duration timeSpent});

/// {@template factory}
/// Factory that creates an instance of [T].
/// {@endtemplate}
abstract class Factory<T> {
  /// {@macro factory}
  const Factory();

  /// Creates an instance of [T].
  T create();
}

/// {@template async_factory}
/// Factory that creates an instance of [T] asynchronously.
/// {@endtemplate}
abstract class AsyncFactory<T> {
  /// {@macro async_factory}
  const AsyncFactory();

  /// Creates an instance of [T].
  Future<T> create();
}

/// {@template dependencies_factory}
/// Factory that creates an instance of [DependenciesContainer].
/// {@endtemplate}
class DependenciesFactory extends AsyncFactory<DependenciesContainer> {
  /// {@macro dependencies_factory}
  const DependenciesFactory({
    required this.config,
    required this.logger,
    required this.errorReporter,
  });

  /// Application configuration
  final ApplicationConfig config;

  /// Logger used to log information during composition process.
  final Logger logger;

  /// Error tracking manager used to track errors in the application.
  final ErrorReporter errorReporter;

  @override
  Future<DependenciesContainer> create() async {
    final dio = const DioFactory().create();

    final sharedPreferences = await SharedPreferences.getInstance();

    final packageInfo = await PackageInfo.fromPlatform();
    // final settingsBloc =
    //     await AppSettingsBlocFactory(sharedPreferencesAsync).create();

    final tokenStorage = TokenStorage(sharedPreferences: sharedPreferences);
    final orgIdStorage = OrganizationIdStorage(
      sharedPreferences: sharedPreferences,
    );
    final authBloc = await AuthBlocFactory(
      dio: dio,
      tokenStorage: tokenStorage,
      orgIdStorage: orgIdStorage,
    ).create();

    final profileBloc = await ProfileBlocFactory(
      dio: dio,
      tokenStorage: tokenStorage,
      orgIdStorage: orgIdStorage,
    ).create();

    return DependenciesContainer(
      logger: logger,
      config: config,
      dio: dio,
      errorReporter: errorReporter,
      packageInfo: packageInfo,
      tokenStorage: tokenStorage,
      organizationIdStorage: orgIdStorage,
      //appSettingsBloc: settingsBloc,
      profileBloc: profileBloc,
      authBloc: authBloc,
    );
  }
}

/// {@template app_logger_factory}
/// Factory that creates an instance of [AppLogger].
/// {@endtemplate}
class AppLoggerFactory extends Factory<AppLogger> {
  /// {@macro app_logger_factory}
  const AppLoggerFactory({this.observers = const []});

  /// List of observers that will be notified when a log message is received.
  final List<LogObserver> observers;

  @override
  AppLogger create() => AppLogger(observers: observers);
}

/// {@template app_logger_factory}
/// Factory that creates an instance of [Dio].
/// {@endtemplate}
class DioFactory extends Factory<Dio> {
  /// {@macro dio_factory}
  const DioFactory({this.observers = const []});

  /// List of observers that will be notified when a log message is received.
  final List<LogObserver> observers;

  @override
  Dio create() {
    /// Interceptor that logs requests and responses
    final dio = Dio()..interceptors.add(LogInterceptor());
    dio.options.baseUrl = AppStrings.baseUrl;
    return dio;
  }
}

/// {@template error_reporter_factory}
/// Factory that creates an instance of [ErrorReporter].
/// {@endtemplate}
class ErrorReporterFactory extends AsyncFactory<ErrorReporter> {
  /// {@macro error_reporter_factory}
  const ErrorReporterFactory(this.config);

  /// Application configuration
  final ApplicationConfig config;

  @override
  Future<ErrorReporter> create() async {
    final errorReporter = SentryErrorReporter(
      sentryDsn: config.sentryDsn,
      environment: config.environment.value,
    );

    if (config.sentryDsn.isNotEmpty) {
      await errorReporter.initialize();
    }

    return errorReporter;
  }
}

// /// {@template app_settings_bloc_factory}
// /// Factory that creates an instance of [AppSettingsBloc].
// ///
// /// The [AppSettingsBloc] should be initialized during the application startup
// /// in order to load the app settings from the local storage, so user can see
// /// their selected theme,locale, etc.
// /// {@endtemplate}
// class AppSettingsBlocFactory extends AsyncFactory<AppSettingsBloc> {
//   /// {@macro app_settings_bloc_factory}
//   const AppSettingsBlocFactory(this.sharedPreferences);

//   /// Shared preferences instance
//   final SharedPreferencesAsync sharedPreferences;

//   @override
//   Future<AppSettingsBloc> create() async {
//     final appSettingsRepository = AppSettingsRepositoryImpl(
//       datasource:
//           AppSettingsDatasourceImpl(sharedPreferences: sharedPreferences),
//     );

//     final appSettings = await appSettingsRepository.getAppSettings();
//     final initialState = AppSettingsState.idle(appSettings: appSettings);

//     return AppSettingsBloc(
//       appSettingsRepository: appSettingsRepository,
//       initialState: initialState,
//     );
//   }
// }

/// {@template auth_bloc_factory}
/// Factory that creates an instance of [AuthBlocFactory].
///
/// The [AuthBlocFactory] should be initialized during the application startup
/// in order to load the auth info from the server, so user can see
/// roles, names and email.
/// {@endtemplate}
class AuthBlocFactory extends AsyncFactory<AuthBloc> {
  /// {@macro auth_bloc_factory}
  const AuthBlocFactory({
    required this.dio,
    required this.tokenStorage,
    required this.orgIdStorage,
  });

  /// Dio instance
  final Dio dio;

  /// TokenStorage instance
  final TokenStorage tokenStorage;

  /// TokenStorage instance
  final OrganizationIdStorage orgIdStorage;

  @override
  Future<AuthBloc> create() async {
    final authDataSource = AuthDataSource(dio: dio);

    final authRepository = AuthRepository(
      dataSource: authDataSource,
      storage: tokenStorage,
      orgIdStorage: orgIdStorage,
    );
    final token = tokenStorage.load();

    return AuthBloc(
      AuthBlocState.idle(
        token: token ?? '',
        status: token != null
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated,
      ),
      authRepository: authRepository,
    );
  }
}

/// {@template app_settings_bloc_factory}
/// Factory that creates an instance of [ProfileBlocFactory].
///
/// The [ProfileBlocFactory] should be initialized during the application startup
/// in order to load the user profile info from the server storage, so user can see
/// their info and role.
/// {@endtemplate}
class ProfileBlocFactory extends AsyncFactory<ProfileBloc> {
  /// {@macro app_settings_bloc_factory}
  const ProfileBlocFactory({
    required this.dio,
    required this.tokenStorage,
    required this.orgIdStorage,
  });

  /// Dio instance
  final Dio dio;

  /// TokenStorage instance
  final TokenStorage tokenStorage;

  /// TokenStorage instance
  final OrganizationIdStorage orgIdStorage;

  @override
  Future<ProfileBloc> create() async {
    final profileDataSource = ProfileDataSource(dio: dio);
    final profileRepository = ProfileRepository(
      dataSource: profileDataSource,
      tokenStorage: tokenStorage,
      orgIdStorage: orgIdStorage,
    );
    return ProfileBloc(profileRepository: profileRepository)
      ..add(const ProfileBlocEvent.fetchUserInfo());
  }
}
