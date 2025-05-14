import 'package:learning_platform/src/feature/authorization/data/data_source/auth_data_source.dart';
import 'package:learning_platform/src/feature/authorization/data/data_source/i_auth_data_source.dart';
import 'package:learning_platform/src/feature/authorization/data/repository/i_auth_repository.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/organization_id_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';
import 'package:learning_platform/src/feature/authorization/model/user_authorized.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

/// Implementation [IAuthRepository]  for authentication operations.
class AuthRepository implements IAuthRepository {
  final IAuthDataSource _dataSource;
  final TokenStorage _storage;
  final IStorage<String> _orgIdStorage;

  /// Create an [AuthRepository]
  const AuthRepository({
    required AuthDataSource dataSource,
    required TokenStorage storage,
    required OrganizationIdStorage orgIdStorage,
  })  : _dataSource = dataSource,
        _storage = storage,
        _orgIdStorage = orgIdStorage;

  @override
  Stream<AuthenticationStatus> get authStatus => _storage.authStream().map(
        (token) => token != null
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated,
      );

  @override
  Future<UserAuthorized> login(
    String organizationId,
    String email,
    String password,
  ) async {
    final data = await _dataSource.login(organizationId, email, password);

    await _storage.save(data.token);
    await _orgIdStorage.save(organizationId);

    return data;
  }

  @override
  Future<void> logout() async {
    await _storage.clear();
    await _orgIdStorage.clear();
  }

  @override
  Future<String> register(
    String organizationId,
    String email,
    String password,
    UserName userName,
  ) async {
    final token = await _dataSource.register(
      organizationId,
      email,
      password,
      userName,
    );

    await _storage.save(token);
    await _orgIdStorage.save(organizationId);

    return token;
  }

  @override
  Future<void> verifyEmail(String code) async {
    await _dataSource.verifyEmail(code);
  }

  @override
  Future<void> sendCodeToEmail() async {
    await _dataSource.sendCodeToEmail();
  }
}
