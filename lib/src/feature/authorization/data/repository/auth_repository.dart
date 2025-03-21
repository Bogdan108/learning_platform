import 'package:learning_platform/src/feature/authorization/data/data_source/auth_data_source.dart';
import 'package:learning_platform/src/feature/authorization/data/repository/i_auth_repository.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';
import 'package:learning_platform/src/feature/authorization/model/auth_status_model.dart';
import 'package:learning_platform/src/feature/profile/model/user_name.dart';

/// Implementation [IAuthRepository]  for authentication operations.
class AuthRepository implements IAuthRepository {
  final AuthDataSource _dataSource;
  final TokenStorage _storage;

  /// Create an [AuthRepository]
  const AuthRepository({
    required AuthDataSource dataSource,
    required TokenStorage storage,
  })  : _dataSource = dataSource,
        _storage = storage;

  @override
  Stream<AuthenticationStatus> get authStatus => _storage.authStream().map(
        (token) => token != null
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated,
      );

  @override
  Future<String> login(
    String organizationId,
    String email,
    String password,
  ) async {
    final token = await _dataSource.login(organizationId, email, password);
    await _storage.save(token);

    return token;
  }

  @override
  Future<void> logout() async {
    await _storage.clear();
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
